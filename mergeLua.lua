#!/usr/bin/lua

-- ============================================================
-- Script : mergeLua.lua
-- Author : J3r3m - https://github.com/J3r3mV
-- Version : 1.0
-- Description : Merges a Lua project into a single file.
--
-- Prerequisites:
--      - "require" are not assigned to a variable, use require("mymodule") directy
--      - LUA modules must be at the same level or in a folder of the entry script. 
-- There will be no access to the module if it is installed on your machine in the 
-- global folders: package.path. Because my need to make scripts standalone and easily
-- distributable without having to install the missing modules.
--
-- Syntax:
--      - mergeLua fileInput.lua fileOutput.lua
-- ============================================================

local PATTERN_REQUIRE = "require%([\'\"]([%w._]+)[\'\"]%)"
local SEP_OS = package.config:sub(1, 1)

local tOutput = {}
local tModules = {}

-- ============================================================
-- FUNCTIONS
-- ============================================================

-- Description : Transforms a file or module name into a physical file name
-- @param sFile (string) : Name module ou name file (with or without extension)
-- @return (string) : Physical path name with extension or folder separator depending on the OS
local function fileToFileNamePhysyque(sFile)
    -- It's a module ! So add extension.
    if not sFile:match("%.lua$") then
        sFile = sFile:gsub("%.", SEP_OS)
        sFile = sFile .. ".lua"
    end
    return sFile
end

-- Description : Run through the script, merging modules recursively while
-- avoiding loops if module already present.
-- @param (string) : File lua, module... Input script
-- @return (string) : Merged script
local function merge(sFilename)

    sFilename = fileToFileNamePhysyque(sFilename)

    local fFile = io.open(sFilename, "r")

    if fFile then

        for sLine in io.lines(sFilename) do
            local sFileModule = sLine:match(PATTERN_REQUIRE)

            if sFileModule then
                -- Module already load ?
                local isLoad = false
                for _, sModule in ipairs(tModules) do
                    if sModule == sFileModule then
                        isLoad = true
                        break
                    end
                end
                -- New require to load
                if not isLoad then
                    table.insert(tModules, sFileModule)
                    table.insert(tOutput, "-- Start : " .. sFileModule .. "\n")
                    sLine = merge(sFileModule)
                    table.insert(tOutput, "-- End : " .. sFileModule .. "\n")
                end
            else
                table.insert(tOutput, sLine)
            end
        end

        fFile:close()

        return table.concat(tOutput, "\n")
    end

    print(sFilename .. " does not exist !")
    os.exit(1)
end

-- ============================================================
-- MAIN
-- ============================================================

-- Parameters

local sFileInput    = arg[1]
local sFileOutput   = arg[2]

if not sFileInput or not sFileOutput then
    print("Parameters missing !\nEx : " .. arg[0] .. " fileInput.lua fileOutput.lua\n")
    os.exit(1)
end

-- Write merged file

local sOneFile = merge(sFileInput)

if sOneFile then
    local fFileOutput = io.open(sFileOutput, "w")
    if fFileOutput then
        fFileOutput:write(sOneFile)
        fFileOutput:close()
        print("Enjoy ! " .. sFileOutput .. " created !")
    end
end
