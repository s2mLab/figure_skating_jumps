package com.example.figure_skating_jumps.x_sens_dot.utils

import android.util.Log
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo

class XSensFileInfoSerializer {
    companion object {
        fun serialize(fileInfo: XsensDotRecordingFileInfo): String {
            return "id: ${fileInfo.fileId}, name: ${fileInfo.fileName}, size: ${fileInfo.dataSize}"
        }

        fun deserialize(serializedFileInfo: String): XsensDotRecordingFileInfo? {
            val splitInfo = serializedFileInfo.split(", ")

            if (splitInfo.size != 3) return null

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