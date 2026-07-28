import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'receipt_printer.dart';

/// Windows yazıcı kuyruğuna RAW datatype ile doğrudan ESC/POS baytı
/// yazar — sürücünün grafik/PDF işleme katmanına hiç girmez, bu yüzden
/// barkod/kesme komutları bozulmadan yazıcıya ulaşır. Yalnızca Windows'ta
/// çalışır; çağıran taraf `Platform.isWindows` ile korumalıdır.
class WindowsRawPrinter implements ReceiptPrinter {
  const WindowsRawPrinter();

  @override
  Future<List<String>> listPrinters() async {
    const flags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS;
    const level = 4;
    final neededBytes = calloc<DWORD>();
    final returnedCount = calloc<DWORD>();

    try {
      EnumPrinters(
        flags,
        nullptr,
        level,
        nullptr,
        0,
        neededBytes,
        returnedCount,
      );

      if (neededBytes.value == 0) {
        return const [];
      }

      final buffer = calloc<Uint8>(neededBytes.value);
      try {
        final ok = EnumPrinters(
          flags,
          nullptr,
          level,
          buffer,
          neededBytes.value,
          neededBytes,
          returnedCount,
        );
        if (ok == 0) {
          throw ReceiptPrinterException(
            'Yazıcı listesi alınamadı (Win32 hata kodu: ${GetLastError()}).',
          );
        }

        final names = <String>[];
        final infoArray = buffer.cast<PRINTER_INFO_4>();
        for (var i = 0; i < returnedCount.value; i++) {
          final info = (infoArray + i).ref;
          if (info.pPrinterName != nullptr) {
            names.add(info.pPrinterName.toDartString());
          }
        }
        return names;
      } finally {
        calloc.free(buffer);
      }
    } finally {
      calloc.free(neededBytes);
      calloc.free(returnedCount);
    }
  }

  @override
  Future<void> printRaw(String target, Uint8List bytes) async {
    final printerNamePtr = target.toNativeUtf16();
    final printerHandlePtr = calloc<HANDLE>();

    try {
      final opened = OpenPrinter(printerNamePtr, printerHandlePtr, nullptr);
      if (opened == 0) {
        throw ReceiptPrinterException(
          'Yazıcı açılamadı: $target (Win32 hata kodu: ${GetLastError()}).',
        );
      }

      final hPrinter = printerHandlePtr.value;
      try {
        _printDocument(hPrinter, bytes);
      } finally {
        ClosePrinter(hPrinter);
      }
    } finally {
      calloc.free(printerNamePtr);
      calloc.free(printerHandlePtr);
    }
  }

  void _printDocument(int hPrinter, Uint8List bytes) {
    final docNamePtr = 'DoTiKa Fiş'.toNativeUtf16();
    final dataTypePtr = 'RAW'.toNativeUtf16();
    final docInfo = calloc<DOC_INFO_1>();
    docInfo.ref
      ..pDocName = docNamePtr
      ..pOutputFile = nullptr
      ..pDatatype = dataTypePtr;

    try {
      final jobId = StartDocPrinter(hPrinter, 1, docInfo.cast());
      if (jobId == 0) {
        throw ReceiptPrinterException(
          'Yazdırma işi başlatılamadı (Win32 hata kodu: ${GetLastError()}).',
        );
      }

      try {
        if (StartPagePrinter(hPrinter) == 0) {
          throw ReceiptPrinterException(
            'Sayfa başlatılamadı (Win32 hata kodu: ${GetLastError()}).',
          );
        }

        try {
          _writeBytes(hPrinter, bytes);
        } finally {
          EndPagePrinter(hPrinter);
        }
      } finally {
        EndDocPrinter(hPrinter);
      }
    } finally {
      calloc.free(docInfo);
      calloc.free(docNamePtr);
      calloc.free(dataTypePtr);
    }
  }

  void _writeBytes(int hPrinter, Uint8List bytes) {
    final dataPtr = calloc<Uint8>(bytes.length);
    final writtenPtr = calloc<DWORD>();
    try {
      dataPtr.asTypedList(bytes.length).setAll(0, bytes);
      final written = WritePrinter(
        hPrinter,
        dataPtr.cast(),
        bytes.length,
        writtenPtr,
      );
      if (written == 0 || writtenPtr.value != bytes.length) {
        throw ReceiptPrinterException(
          'Veri yazıcıya iletilemedi (Win32 hata kodu: ${GetLastError()}).',
        );
      }
    } finally {
      calloc.free(dataPtr);
      calloc.free(writtenPtr);
    }
  }
}
