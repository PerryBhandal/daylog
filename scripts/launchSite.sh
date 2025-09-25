#!/bin/bash

# Set up rbenv environment
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Change to the application directory
cd ..

# Start the Rails server in a screen session with proper Ruby environment
screen -dmS dayLogSite bash -c 'export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; rails server -e production -b 0.0.0.0 -p 52553'

echo "DayLog server started in screen session 'dayLogSite'"
echo "To view the server output: screen -r dayLogSite"
echo "To detach from screen session: Ctrl+A then D"
echo "To stop the server: screen -S dayLogSite -X quit"
