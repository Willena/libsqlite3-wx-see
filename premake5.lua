-- Build SQLite3
--   static or shared library
--   AES 128 bit or AES 256 bit encryption support
--   Debug or Release
--   Win32 or Win64

-- Target directory for the build files generated by premake5
newoption {
  trigger     = "builddir",
  value       = "build",
  description = "Directory for the generated build files"
}

BUILDDIR = _OPTIONS["builddir"] or "build"

workspace "SQLite3"
  configurations { "Debug AES128", "Release AES128", "Debug AES256", "Release AES256" }
  platforms { "Win32", "Win64" }
  location(BUILDDIR)

  defines {
    "_WINDOWS",
    "WIN32",
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  filter { "platforms:Win32" }
    system "Windows"
    architecture "x32"

  filter { "platforms:Win64" }
    system "Windows"
    architecture "x64"
    targetsuffix "_x64"

  filter { "configurations:Debug*" }
    defines {
      "DEBUG", 
      "_DEBUG"
    }
    symbols "On"

  filter { "configurations:Release*" }
    defines {
      "NDEBUG"
    }
    flags { "Optimize" }  

  filter {}

-- SQLite3 static library
project "sqlite3lib"
  language "C++"
  kind "StaticLib"

  files { "src/sqlite3secure.c", "src/*.h" }
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**/sqlite3secure.c", "**.def", "**.rc" }
  }
  characterset ("Unicode")
  flags { "StaticRuntime" }  

  location( BUILDDIR )
  targetname "sqlite3"

  defines {
    "_LIB",
    "THREADSAFE=1",
    "SQLITE_MAX_ATTACHED=10",
    "SQLITE_ENABLE_EXPLAIN_COMMENTS",
    "SQLITE_SOUNDEX",
    "SQLITE_ENABLE_COLUMN_METADATA",
    "SQLITE_HAS_CODEC=1",
    "SQLITE_SECURE_DELETE",
    "SQLITE_ENABLE_FTS3",
    "SQLITE_ENABLE_FTS3_PARENTHESIS",
    "SQLITE_ENABLE_FTS4",
    "SQLITE_ENABLE_FTS5",
    "SQLITE_ENABLE_JSON1",
    "SQLITE_ENABLE_RTREE",
    "SQLITE_CORE",
    "SQLITE_ENABLE_EXTFUNC",
    "SQLITE_ENABLE_CSV",
--    "SQLITE_ENABLE_SHA3",
    "SQLITE_ENABLE_CARRAY",
--    "SQLITE_ENABLE_FILEIO",
    "SQLITE_ENABLE_SERIES",
    "SQLITE_USE_URI",
    "SQLITE_USER_AUTHENTICATION"
  }

  -- Encryption type
  filter { "configurations:*AES128" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128"
    }
  filter { "configurations:*AES256" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256"
    }

  -- Target directory
  filter { "configurations:Debug AES128" }
    targetdir "aes128/lib/debug"
  filter { "configurations:Debug AES256" }
    targetdir "aes256/lib/debug"
  filter { "configurations:Release AES128" }
    targetdir "aes128/lib/release"
  filter { "configurations:Release AES256" }
    targetdir "aes256/lib/release"

-- SQLite3 shared library
project "sqlite3dll"
  language "C++"
  kind "SharedLib"

  files { "src/sqlite3secure.c", "src/*.h", "src/sqlite3.def", "src/sqlite3.rc" }
  filter {}
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**/sqlite3secure.c", "**.def", "**.rc" }
  }
  characterset ("Unicode")
  flags { "StaticRuntime" }  

  location( BUILDDIR )
  targetname "sqlite3"

  defines {
    "_USRDLL",
    "THREADSAFE=1",
    "SQLITE_MAX_ATTACHED=10",
    "SQLITE_SOUNDEX",
    "SQLITE_ENABLE_COLUMN_METADATA",
    "SQLITE_HAS_CODEC=1",
    "SQLITE_SECURE_DELETE",
    "SQLITE_ENABLE_FTS3",
    "SQLITE_ENABLE_FTS3_PARENTHESIS",
    "SQLITE_ENABLE_FTS4",
    "SQLITE_ENABLE_FTS5",
    "SQLITE_ENABLE_JSON1",
    "SQLITE_ENABLE_RTREE",
    "SQLITE_CORE",
    "SQLITE_ENABLE_EXTFUNC",
    "SQLITE_ENABLE_CSV",
    "SQLITE_ENABLE_SHA3",
    "SQLITE_ENABLE_CARRAY",
    "SQLITE_ENABLE_FILEIO",
    "SQLITE_ENABLE_SERIES",
    "SQLITE_USE_URI",
    "SQLITE_USER_AUTHENTICATION"
  }

  -- Encryption type
  filter { "configurations:*AES128" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128"
    }
  filter { "configurations:*AES256" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256"
    }

  -- Target directory
  filter { "configurations:Debug AES128" }
    targetdir "aes128/dll/debug"
  filter { "configurations:Debug AES256" }
    targetdir "aes256/dll/debug"
  filter { "configurations:Release AES128" }
    targetdir "aes128/dll/release"
  filter { "configurations:Release AES256" }
    targetdir "aes256/dll/release"

-- SQLite3 Shell    
project "sqlite3shell"
  kind "ConsoleApp"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.c", "**.rc" }
  }
  files { "src/sqlite3.h", "src/shell.c", "src/sqlite3shell.rc" }
  characterset ("Unicode")
  flags { "StaticRuntime" }  
  links { "sqlite3lib" }

  location( BUILDDIR )

  defines {
    "SQLITE_SHELL_IS_UTF8",
    "SQLITE_HAS_CODEC=1",
    "SQLITE_USER_AUTHENTICATION"
  }

  -- Target directory
  filter { "configurations:Debug AES128" }
    targetdir "aes128/lib/debug"
  filter { "configurations:Debug AES256" }
    targetdir "aes256/lib/debug"
  filter { "configurations:Release AES128" }
    targetdir "aes128/lib/release"
  filter { "configurations:Release AES256" }
    targetdir "aes256/lib/release"


-- ICU support
-- SQLite3 static library with ICU support
project "sqlite3libicu"
  language "C++"
  kind "StaticLib"

  files { "src/sqlite3secure.c", "src/*.h" }
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**/sqlite3secure.c", "**.def", "**.rc" }
  }
  characterset ("Unicode")
  flags { "StaticRuntime" }
  includedirs { "$(LIBICU_PATH)/include" }

  location( BUILDDIR )
  targetname "sqlite3icu"

  defines {
    "_LIB",
    "THREADSAFE=1",
    "SQLITE_ENABLE_ICU",
    "SQLITE_MAX_ATTACHED=10",
    "SQLITE_ENABLE_EXPLAIN_COMMENTS",
    "SQLITE_SOUNDEX",
    "SQLITE_ENABLE_COLUMN_METADATA",
    "SQLITE_HAS_CODEC=1",
    "SQLITE_SECURE_DELETE",
    "SQLITE_ENABLE_FTS3",
    "SQLITE_ENABLE_FTS3_PARENTHESIS",
    "SQLITE_ENABLE_FTS4",
    "SQLITE_ENABLE_FTS5",
    "SQLITE_ENABLE_JSON1",
    "SQLITE_ENABLE_RTREE",
    "SQLITE_CORE",
    "SQLITE_ENABLE_EXTFUNC",
    "SQLITE_ENABLE_CSV",
--    "SQLITE_ENABLE_SHA3",
    "SQLITE_ENABLE_CARRAY",
--    "SQLITE_ENABLE_FILEIO",
    "SQLITE_ENABLE_SERIES",
    "SQLITE_USE_URI",
    "SQLITE_USER_AUTHENTICATION"
  }

  -- Encryption type
  filter { "configurations:*AES128" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128"
    }
  filter { "configurations:*AES256" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256"
    }

  -- Target directory
  filter { "configurations:Debug AES128" }
    targetdir "aes128/lib/debug"
  filter { "configurations:Debug AES256" }
    targetdir "aes256/lib/debug"
  filter { "configurations:Release AES128" }
    targetdir "aes128/lib/release"
  filter { "configurations:Release AES256" }
    targetdir "aes256/lib/release"

-- SQLite3 shared library with ICU support
project "sqlite3dllicu"
  language "C++"
  kind "SharedLib"

  files { "src/sqlite3secure.c", "src/*.h", "src/sqlite3.def", "src/sqlite3.rc" }
  filter {}
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**/sqlite3secure.c", "**.def", "**.rc" }
  }
  characterset ("Unicode")
  flags { "StaticRuntime" } 
  includedirs { "$(LIBICU_PATH)/include" }  

  filter { "platforms:Win32" }
    libdirs { "$(LIBICU_PATH)/lib" }
  filter { "platforms:Win64" }
    libdirs { "$(LIBICU_PATH)/lib64" }
  filter {}

  filter { "configurations:Debug*" }
    links { "icuind", "icuucd" }
  filter { "configurations:Release*" }
    links { "icuin", "icuuc" }
  filter {}

  location( BUILDDIR )
  targetname "sqlite3icu"

  defines {
    "_USRDLL",
    "THREADSAFE=1",
    "SQLITE_ENABLE_ICU",
    "SQLITE_MAX_ATTACHED=10",
    "SQLITE_SOUNDEX",
    "SQLITE_ENABLE_COLUMN_METADATA",
    "SQLITE_HAS_CODEC=1",
    "SQLITE_SECURE_DELETE",
    "SQLITE_ENABLE_FTS3",
    "SQLITE_ENABLE_FTS3_PARENTHESIS",
    "SQLITE_ENABLE_FTS4",
    "SQLITE_ENABLE_FTS5",
    "SQLITE_ENABLE_JSON1",
    "SQLITE_ENABLE_RTREE",
    "SQLITE_CORE",
    "SQLITE_ENABLE_EXTFUNC",
    "SQLITE_ENABLE_CSV",
    "SQLITE_ENABLE_SHA3",
    "SQLITE_ENABLE_CARRAY",
    "SQLITE_ENABLE_FILEIO",
    "SQLITE_ENABLE_SERIES",
    "SQLITE_USE_URI",
    "SQLITE_USER_AUTHENTICATION"
  }

  -- Encryption type
  filter { "configurations:*AES128" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128"
    }
  filter { "configurations:*AES256" }
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256"
    }

  -- Target directory
  filter { "configurations:Debug AES128" }
    targetdir "aes128/dll/debug"
  filter { "configurations:Debug AES256" }
    targetdir "aes256/dll/debug"
  filter { "configurations:Release AES128" }
    targetdir "aes128/dll/release"
  filter { "configurations:Release AES256" }
    targetdir "aes256/dll/release"

-- SQLite3 Shell with ICU support   
project "sqlite3shellicu"
  kind "ConsoleApp"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.c", "**.rc" }
  }
  files { "src/sqlite3.h", "src/shell.c", "src/sqlite3shell.rc" }
  characterset ("Unicode")
  flags { "StaticRuntime" }  
  links { "sqlite3libicu" }

  filter { "platforms:Win32" }
    libdirs { "$(LIBICU_PATH)/lib" }  
  filter { "platforms:Win64" }
    libdirs { "$(LIBICU_PATH)/lib64" }  
  filter {}

  filter { "configurations:Debug*" }
    links { "icuind", "icuucd" }
  filter { "configurations:Release*" }
    links { "icuin", "icuuc" }
  filter {}

  location( BUILDDIR )

  defines {
    "SQLITE_SHELL_IS_UTF8",
    "SQLITE_HAS_CODEC=1",
    "SQLITE_USER_AUTHENTICATION"
  }

  -- Target directory
  filter { "configurations:Debug AES128" }
    targetdir "aes128/lib/debug"
  filter { "configurations:Debug AES256" }
    targetdir "aes256/lib/debug"
  filter { "configurations:Release AES128" }
    targetdir "aes128/lib/release"
  filter { "configurations:Release AES256" }
    targetdir "aes256/lib/release"
