/// The File class holds the data of a single file. The File class provides the minimum interface required for a file. Additional functions are added to the module for manipulating chunked data.

import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Time "mo:base/Time";

import Itertools "mo:Itertools/Iter";

import { BufferModule } "Utils";

module {

    type Buffer<A> = Buffer.Buffer<A>;
    type Iter<A> = Iter.Iter<A>;

    /// Required arguements for initializing a `File`
    public type FileData = {
        filename : Text;
        mimeType : Text;
        lastModified : ?Time.Time;
    };

    public class File(fileData : FileData, fileBlob : Blob) {

        /// The name and extention of the file.
        public let filename = fileData.filename;

        /// The MIME type of the file
        public let mimeType = fileData.mimeType;

        /// The UTC timestamp when the file was last modified
        public let lastModified = switch (fileData.lastModified) {
            case (?time) time;
            case (null) Time.now();
        };

        let buffer = Buffer.fromArray<Nat8>(Blob.toArray(fileBlob));

        /// The number of bytes of the file
        public func size() : Nat {
            buffer.size();
        };

        /// Get's the file's data as a Blob
        public func blob() : Blob {
            Blob.fromArray(Buffer.toArray(buffer));
        };

        /// Append a `Blob` of data to the `File`
        public func append(blob : Blob) {
            for (n in Blob.toArray(blob).vals()) {
                buffer.add(n);
            };
        };

        /// Returns a slice of the File's data
        /// specified by the `start` and `end` indices
        public func slice(start : Nat, end : Nat) : Blob {
            let _end = Nat.min(end, buffer.size());
            let len = if (start > _end) { 0 } else { (_end - start) : Nat };

            let bytes = Array.tabulate(
                len,
                func(i : Nat) : Nat8 {
                    buffer.get(i);
                },
            );

            Blob.fromArray(bytes);
        };
    };

    /// Creates a file from an array of consecutive blob slices of the file's dataa
    public func fromChunks(fileData : FileData, chunks : [Blob]) : File {
        let file = File(fileData, chunks[0]);

        for (i in Itertools.range(1, chunks.size())) {
            file.append(chunks[i]);
        };

        file;
    };

    /// Retrieves a slice of the File's data with the start and end
    /// calculated from the `chunkSize` and `chunkIndex`
    public func getChunk(file : File, chunkSize : Nat, chunkIndex : Nat) : Blob {
        let start = chunkSize * chunkIndex;
        let end = Nat.min(start + chunkSize, file.size());

        file.slice(start, end);
    };

    /// Returns an Array of Blob slices which are less than or equal to the
    /// given `chunkSize` and contain consecutive slices of the File's data.
    public func chunks(file : File, chunkSize : Nat) : [Blob] {
        let size = file.size();

        let total_chunks = if (size % chunkSize == 0) {
            (size / chunkSize);
        } else {
            (size / chunkSize) + 1;
        };

        Array.tabulate(
            total_chunks,
            func(i : Nat) : Blob {
                getChunk(file, chunkSize, i);
            },
        );
    };

    /// Attemps to convert the File's data to `Text`
    ///
    /// It returns `null` if the File is not `utf8` encoded
    public func toText(file : File) : ?Text {
        Text.decodeUtf8(file.blob());
    };
};
