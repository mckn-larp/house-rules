#!/bin/bash

# Prompt the user for the file containing the links
echo "Please enter the path to the file containing the markdown links (e.g., readme.md):"
read LINK_FILE

# Check if the link file exists
if [[ ! -f "$LINK_FILE" ]]; then
    echo "The specified file containing the links does not exist: $LINK_FILE"
    exit 1
fi

# Prompt the user for the template path
echo "Please enter the path to the template file:"
read TEMPLATE_PATH

# Check if the template file exists
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo "The specified template file does not exist: $TEMPLATE_PATH"
    exit 1
fi

# Read the link file line by line
while IFS= read -r line; do
    # Extract the relative path of the file from the markdown link
    # It assumes the file paths are in the format ./path/to/file.md
    LINK=$(echo "$line" | sed -n 's/.*(\.\(.*\.md\)).*/\1/p')
    
    if [[ -n $LINK ]]; then
        # Prepend './' to the link since we're capturing the path inside the brackets
        LINK="./$LINK"
        
        # Create the directory if it doesn't exist
        DIR=$(dirname "$LINK")
        if [[ ! -d "$DIR" ]]; then
            echo "Directory $DIR does not exist, creating it."
            mkdir -p "$DIR"
        fi

        # If the file already exists, skip it
        if [[ -f "$LINK" ]]; then
            echo "File $LINK already exists, skipping..."
        else
            # If the file doesn't exist, create it and copy the template
            echo "File $LINK does not exist, creating it."
            touch "$LINK"
            echo "Copying template to $LINK"
            cat "$TEMPLATE_PATH" > "$LINK"
        fi
    fi
done < "$LINK_FILE"

echo "Process completed."
