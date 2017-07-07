//
//  Streams.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 26/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Streams {

    static let byteSize = 1
    static let characterSize = 2
    static let integerSize = 4
    static let longSize = 8

    static let bitsInAByte : Int = 8
    static let maximumValueOfAByte : UInt8 = 0xFF
    
    public static func inputStreams(_ resources: [(name: String, ext: String)]) -> [(url: URL, inputStream: InputStream)]? {
        var inputStreams : [(url: URL, inputStream: InputStream)] = []
        
        for (name, ext) in resources {
            if let url = Bundle.main.url(forResource: name, withExtension: ext), let inputStream = InputStream(url: url) {
                inputStreams.append(url: url, inputStream: inputStream)
            } else {
                return nil
            }
        }
        
        return inputStreams
    }
    
    public static func readByte(_ inputStream: InputStream) -> UInt8 {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: byteSize)
        let read = inputStream.read(buffer, maxLength: byteSize)
        
        var result : UInt8 = 0
        
        if read == byteSize {
            result = buffer[0]
        }
        
        buffer.deinitialize()
        
        return result
    }
    
    public static func writeBytes<T>(_ buffer: UnsafeMutablePointer<T>, count: Int, outputStream: OutputStream) {
        buffer.withMemoryRebound(to: UInt8.self, capacity: count) { (byteBuffer) -> Void in
            outputStream.write(byteBuffer, maxLength: count)
        }
    }
    
    public static func readBoolean(_ inputStream : InputStream) -> Bool {
        return readByte(inputStream) == 1
    }
    
    public static func readInt(_ inputStream : InputStream) -> Int {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: integerSize)
        let read = inputStream.read(buffer, maxLength: integerSize)
        
        let result: Int
        
        if read == integerSize {
            result = buffer.withMemoryRebound(to: Int32.self, capacity: 1) { Int($0[0]) }
        } else {
            result = 0
        }
        
        buffer.deinitialize()
        
        return result
    }
    
    public static func writeInt(_ int: Int, outputStream: OutputStream) {
        let buffer = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        buffer[0] = Int32(int)
        
        writeBytes(buffer, count: integerSize, outputStream: outputStream)
        buffer.deinitialize()
    }
    
    public static func writeCharacter(_ character: Character, outputStream: OutputStream) {
        let buffer = UnsafeMutablePointer<Character>.allocate(capacity: 1)
        buffer[0] = character
        
        writeBytes(buffer, count: characterSize, outputStream: outputStream)
        buffer.deinitialize()
    }
    
    public static func readFloat(_ inputStream : InputStream) -> Float {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: integerSize)
        let read = inputStream.read(buffer, maxLength: integerSize)
        
        let result: Float
        
        if read == integerSize {
            result = buffer.withMemoryRebound(to: Float32.self, capacity: 1) { $0[0] }
        } else {
            result = 0
        }
        
        buffer.deinitialize()
        
        return result
    }
    
    public static func readDouble(_ inputStream : InputStream) -> Double {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: longSize)
        let read = inputStream.read(buffer, maxLength: longSize)
        
        let result: Double
        
        if read == longSize {
            result = buffer.withMemoryRebound(to: Float64.self, capacity: 1) { $0[0] }
        } else {
            result = 0
        }
        
        buffer.deinitialize()
        
        return result
    }
    
    public static func readByteArray(_ inputStream : InputStream) -> [UInt8] {
        let count = readInt(inputStream)
        var result = [UInt8]()
        result.reserveCapacity(count)
        
        for _ in 0..<count {
            result.append(readByte(inputStream))
        }
        
        return result
    }
    
    public static func readNullableByteArray(_ inputStream : InputStream) -> [UInt8]? {
        if readBoolean(inputStream) {
            return readByteArray(inputStream)
        } else {
            return nil
        }
    }
    
    public static func readIntArray(_ inputStream : InputStream) -> [Int] {
        let count = readInt(inputStream)
        var result = [Int]()
        result.reserveCapacity(count)
        
        for _ in 0..<count {
            result.append(readInt(inputStream))
        }
        
        return result
    }
    
    public static func readString(_ inputStream : InputStream) -> String {
        let length = readInt(inputStream) * characterSize
        
        if length == 0 {
            return ""
        }
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        let read = inputStream.read(buffer, maxLength: length)
        
        let string: String
        
        if read == length {
            string = String(data: Data(bytes: buffer, count: length), encoding: String.Encoding.utf16LittleEndian)!
        } else {
            string = ""
        }
        
        buffer.deinitialize()
        
        return string
    }
    
    public static func readNullableString(_ inputStream : InputStream) -> String? {
        if readBoolean(inputStream) {
            return readString(inputStream)
        } else {
            return nil
        }
    }
    
    public static func readColor(_ inputStream : InputStream) -> Color<GLfloat> {
        let red = GLfloat(readInt(inputStream)) / 255
        let green = GLfloat(readInt(inputStream)) / 255
        let blue = GLfloat(readInt(inputStream)) / 255
        let alpha = GLfloat(readInt(inputStream)) / 255
        
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static func readPoint(_ inputStream: InputStream) -> Point<GLfloat> {
        let x = readFloat(inputStream)
        let y = readFloat(inputStream)
        return Point<GLfloat>(x: x, y: y)
    }
    
    public static func readFloatFromByteArray(_ bytes: [UInt8], atIndex start: Int) -> (float: Float, readCount: Int) {
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        pointer[0] = bytes[start + 0]
        pointer[1] = bytes[start + 1]
        pointer[2] = bytes[start + 2]
        pointer[3] = bytes[start + 3]
        
        let float = pointer.withMemoryRebound(to: Float32.self, capacity: 1) { $0[0] }
        pointer.deinitialize()
        
        return (float: float, readCount: 4)
    }
    
    public static func readStringFromByteArray(_ bytes: [UInt8], atIndex start: Int) -> (string: String, readCount: Int) {
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        pointer[0] = bytes[start + 0]
        pointer[1] = bytes[start + 1]
        pointer[2] = bytes[start + 2]
        pointer[3] = bytes[start + 3]
        
        let length = pointer.withMemoryRebound(to: Int32.self, capacity: 1) {
            Int($0[0]) * Streams.characterSize
        }
        pointer.deinitialize()
        
        var read = start + 4
        
        let string: String
        
        if length > 0 {
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
            for i in 0 ..< length {
                buffer[i] = bytes[read + i]
            }
            read += length
            
            string = String(data: Data(bytes: buffer, count: length), encoding: String.Encoding.utf16LittleEndian)!
            buffer.deinitialize()
            
        } else {
            string = ""
        }
        
        return (string: string, readCount: read - start)
    }

}
