#!/usr/bin/env bash

# Enhanced TTS script with --hd and --voice flags

# Usage Information
usage() {
  echo "Usage: $0 [-i <text>] [--hd] [--voice <voice>] [-o <output_file.mp3>]"
  echo "-i <text>     - The text to convert to speech if not reading from stdin."
  echo "--hd          - Optional. Enable hd voice quality. Default is standard quality."
  echo "--voice <voice> - Optional. Specify the voice ('alloy', 'echo', 'fable', 'onyx', 'nova', or 'shimmer'). Default is 'alloy'."
  echo "-o <output>   - Specify the output file. Default is 'output.mp3'."
  exit 1
}

# Checking for help argument or no arguments/stdin
if [[ $1 = "--help" || $# -eq 0 ]]; then
  usage
  exit 0
fi

# Verify that an API key is set
if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "Error: The environment variable 'OPENAI_API_KEY' is not set."
  exit 1
fi

# Default values
OUTPUT_FILE="output.mp3"
TEXT=""
VOICE="alloy"
MODEL="tts-1"

# Parse arguments
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
      -h|--help)
      usage
      exit 0
      ;;
      -i)
      TEXT="$2"
      shift # past argument
      shift # past value
      ;;
      --hd)
      MODEL="tts-1-hd"
      shift # past argument
      ;;
      --voice)
      VOICE="$2"
      shift # past argument
      shift # past value
      ;;
      -o)
      OUTPUT_FILE="$2"
      shift # past argument
      shift # past value
      ;;
      *)    # unknown option
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

# If no input text provided, read from stdin
if [ -z "$TEXT" ]; then
    read -r TEXT
fi

# Validate voice option
case $VOICE in
    alloy|echo|fable|onyx|nova|shimmer)
    ;;
    *)
    echo "Invalid voice: $VOICE"
    usage
    exit 1
    ;;
esac


# Make API call to generate speech
echo "Processing: \"$TEXT\" with voice: $VOICE and model: $MODEL"
curl -s https://api.openai.com/v1/audio/speech \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$MODEL\",
    \"input\": \"$TEXT\",
    \"voice\": \"$VOICE\"
  }" \
  --output "$OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
  echo "Audio file created: $OUTPUT_FILE"
else
  echo "An error occurred creating the audio file."
fi
