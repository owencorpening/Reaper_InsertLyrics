-- Add the current script directory to the package search path
local script_dir = debug.getinfo(1, "S").source:match("@(.*[\\/])")
package.path = package.path .. ";" .. script_dir .. "?.lua"

-- Clear previous console messages
reaper.ShowConsoleMsg("Starting Insert Lyrics Script...\n")

-- Get the "Lyrics" track from the current project
function get_lyrics_track()
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if track_name == "Lyrics" then
            reaper.ShowConsoleMsg("Found track 'Lyrics'.\n")
            return track
        end
    end
    reaper.ShowConsoleMsg("Track 'Lyrics' not found.\n")
    return nil
end

-- Read and parse the Whisper JSON file
function read_whisper_json(file_path)
    reaper.ShowConsoleMsg("Opening JSON file: " .. file_path .. "\n")
    local file = io.open(file_path, "r")
    if not file then 
        return nil, "Error opening file"
    end
    local content = file:read("*all")
    file:close()

    local json = require("dkjson")  -- Ensure dkjson.lua is installed in the same directory or in the package path
    local data, pos, err = json.decode(content, 1, nil)
    if err then 
        return nil, "Error parsing JSON: " .. err 
    end

    reaper.ShowConsoleMsg("JSON file parsed successfully.\n")
    return data
end

-- Insert lyrics into the "Lyrics" track using transcription data
function insert_lyrics(whisper_data)
    local track = get_lyrics_track()
    if not track then
        reaper.ShowMessageBox("No track named 'Lyrics' found.", "Error", 0)
        return
    end

    -- Check if transcription data exists
    if not whisper_data.transcription then
        reaper.ShowMessageBox("The JSON file does not contain a 'transcription' array.", "Error", 0)
        return
    end

    reaper.ShowConsoleMsg("Inserting lyrics...\n")
    reaper.Undo_BeginBlock()

    -- Iterate over each transcription entry
    for i, entry in ipairs(whisper_data.transcription) do
        local lyric = entry["text"]
        local start = entry["offsets"]["from"] / 1000  -- Convert ms to seconds
        local _end = entry["offsets"]["to"] / 1000

        reaper.ShowConsoleMsg(string.format("Processing entry %d: start=%.3f, end=%.3f\n", i, start, _end))
        
        if lyric and lyric:match("%S") then  -- Skip empty lyrics
            local item = reaper.AddMediaItemToTrack(track)
            reaper.SetMediaItemInfo_Value(item, "D_POSITION", start)
            reaper.SetMediaItemInfo_Value(item, "D_LENGTH", _end - start)
            
            local take = reaper.AddTakeToMediaItem(item)
            if take then
                reaper.ULT_SetMediaItemNote(item, lyric)
            else
                reaper.ShowConsoleMsg("Warning: Could not add take for entry " .. i .. "\n")
            end
        else
            reaper.ShowConsoleMsg("Skipping empty lyric at entry " .. i .. "\n")
        end
    end

    reaper.Undo_EndBlock("Insert Lyrics", -1)
    reaper.ShowConsoleMsg("Finished inserting lyrics.\n")
end

-- Ask user to select the Whisper JSON file
local ret_val, file_path = reaper.GetUserFileNameForRead("", "Select Whisper JSON File", "*.json")
if ret_val then
    local whisper_data, err = read_whisper_json(file_path)
    if whisper_data then
        insert_lyrics(whisper_data)
    else
        reaper.ShowMessageBox("Error: " .. err, "File Error", 0)
    end
else
    reaper.ShowConsoleMsg("No file selected.\n")
end
