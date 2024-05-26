#!/usr/bin/env bash

# Enhanced STT script

# Usage Information
usage() {
  echo "Usage: $0 [-m <model>] [-f <response_format>] [-l <language>] [--timestamp <timestamp_granularity>] [-o <output_file>] [audio_file]"
  echo "-m <model>                 - Optional. Specify the Whisper model to use. Default is 'whisper-1'."
  echo "-f <response_format>       - Optional. Specify the response format ('json', 'text', 'verbose_json'). Default is 'text'."
  echo "-l <language>              - Optional. Specify the language code if known."
  echo "--timestamp <granularity>  - Optional. Specify timestamp granularity ('word', 'segment', 'none'). Default is 'none'."
  echo "-o <output>                - Optional. Specify the output file. By default, output is printed to stdout."
  echo "audio_file                - The path to the audio file."
  exit 1
}

# Default values
MODEL="whisper-1"
RESPONSE_FORMAT="text"  # Default response format is text passed to stdout
TIMESTAMP="none"
LANGUAGE=""
OUTPUT_FILE=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -m)
      MODEL="$2"
      shift
      ;;
    -f)
      RESPONSE_FORMAT="$2"
      shift
      ;;
    -l)
      LANGUAGE="$2"
      shift
      ;;
    --timestamp)
      TIMESTAMP="$2"
      shift
      ;;
    -o)
      OUTPUT_FILE="$2"
      shift
      ;;
    *)
      # Assuming any other input as the audio_file
      if [[ -n "$AUDIO_FILE" ]]; then
        echo "Error: Multiple audio files specified."
        usage
      else
        AUDIO_FILE="$1"
      fi
      ;;
  esac
  shift
done

# Verify that an API key is set
if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "Error: The environment variable 'OPENAI_API_KEY' is not set."
  exit 2
fi

# Validate that an audio file is provided
if [[ -z "$AUDIO_FILE" ]]; then
  echo "Error: No audio file provided."
  usage
fi

# Validate the audio file exists
if [[ ! -f "$AUDIO_FILE" ]]; then
  echo "Error: The specified audio file does not exist."
  exit 3
fi

# Build the curl command dynamically based on input parameters
CMD=(
  curl --request POST
  --url https://api.openai.com/v1/audio/transcriptions
  --header "Authorization: Bearer $OPENAI_API_KEY"
  --header 'Content-Type: multipart/form-data'
  --form file=@"$AUDIO_FILE"
  --form model="$MODEL"
  --form response_format="$RESPONSE_FORMAT"
)

# Optionally add language and timestamp granularity, if specified
[[ -n "$LANGUAGE" ]] && CMD+=(--form "language=$LANGUAGE")
[[ "$TIMESTAMP" != "none" ]] && CMD+=(--form "timestamp_granularities[]=$TIMESTAMP")

# Check if an output file is specified
if [[ -n "$OUTPUT_FILE" ]]; then
  # Execute the curl command and save output to file
  "${CMD[@]}" --output "$OUTPUT_FILE"
  if [[ $? -eq 0 ]]; then
    echo "Transcription created: $OUTPUT_FILE"
  else
    echo "An error occurred creating the transcription."
    exit 4
  fi
else
  # Execute the curl command and output directly to stdout
  "${CMD[@]}"
  if [[ $? -ne 0 ]]; then
    echo "An error occurred creating the transcription."
    exit 4
  fi
fi
