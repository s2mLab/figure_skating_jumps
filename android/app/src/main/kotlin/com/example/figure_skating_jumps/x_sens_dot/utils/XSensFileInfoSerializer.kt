package com.example.figure_skating_jumps.x_sens_dot.utils

import android.util.Log
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo

/**
 * A class to serialize and deserialize XSensFileInfo
 */
class XSensFileInfoSerializer {
    companion object {
        private const val nbExpectedParams = 3

        /**
         * Serialize a file info
         *
         * @param fileInfo The file info to serialize
         *
         * @return [String] the serialized file info
         */
        fun serialize(fileInfo: XsensDotRecordingFileInfo): String {
            return "id: ${fileInfo.fileId}, name: ${fileInfo.fileName}, size: ${fileInfo.dataSize}"
        }

        /**
         * Deserialize a [String] into a file info
         *
         * @param serializedFileInfo The serialized file info
         *
         * @return [XsensDotRecordingFileInfo] the deserialized file info
         */
        fun deserialize(serializedFileInfo: String): XsensDotRecordingFileInfo? {
            val splitInfo = serializedFileInfo.split(", ")

            if (splitInfo.size != nbExpectedParams) return null

            val id: Int
            val name: String
            val size: Int

            try {
                id = splitInfo[0].split(": ")[1].toInt()
                name = splitInfo[1].split(": ")[1]
                size = splitInfo[2].split(": ")[1].toInt()
            } catch (e: Exception) {
                Log.e("XSensFileInfoSerializer", e.message!!)
                return null
            }

            return XsensDotRecordingFileInfo(id, name, size)
        }
    }
}