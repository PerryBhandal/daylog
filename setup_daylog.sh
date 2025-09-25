#!/bin/bash

# Setup script for DayLog application on a fresh Debian/Ubuntu installation
# This script will install all necessary dependencies and set up the application
#
# Usage:
#   SOURCE_DIR=/path/to/daylog ./setup_daylog.sh
#
# Where:
#   SOURCE_DIR is the path to the daylog repository on your system
#
# Example:
#   SOURCE_DIR=/home/perry/git/daylog ./setup_daylog.sh

set -e  # Exit on error

# Check if running as root
if [ "$(id -u)" = "0" ]; then
   echo "ERROR: This script should NOT be run as root or with 'sudo su'!"
   echo ""
   echo "Please run this script as a regular user. The script will use 'sudo'"
   echo "for commands that require elevated privileges."
   echo ""
   echo "If you're currently in 'sudo su' mode, please exit and run:"
   echo "  SOURCE_DIR=/path/to/daylog ./setup_daylog.sh"
   echo ""
   echo "Or if running from the daylog directory:"
   echo "  ./setup_daylog.sh"
   exit 1
fi

echo "=== Setting up DayLog application ==="

# Update package lists
echo "=== Updating package lists ==="
sudo apt-get update

# Install system dependencies
echo "=== Installing system dependencies ==="
sudo apt-get install -y git curl build-essential libssl-dev libreadline-dev \
  zlib1g-dev sqlite3 libsqlite3-dev nodejs screen libnotify-bin

# Install rbenv for Ruby version management
echo "=== Installing rbenv ==="
if [ ! -d "$HOME/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

# Set up rbenv in current session
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Install Ruby 2.3.3
echo "=== Installing Ruby 2.3.3 (this may take a while) ==="
# Skip documentation generation to avoid Marshal.dump error
export RUBY_CONFIGURE_OPTS="--disable-install-doc"
rbenv install -s 2.3.3
rbenv global 2.3.3

# Refresh rbenv shims and verify Ruby version
rbenv rehash
export PATH="$HOME/.rbenv/shims:$PATH"

# Verify Ruby version
echo "=== Verifying Ruby version ==="
RUBY_VERSION=$(ruby -v)
echo "Current Ruby version: $RUBY_VERSION"
if ! ruby -v | grep -q "2.3.3"; then
  echo "ERROR: Ruby 2.3.3 is not active. Current version: $(ruby -v)"
  echo "Attempting to fix..."
  rbenv shell 2.3.3
  export PATH="$HOME/.rbenv/versions/2.3.3/bin:$PATH"
  echo "Ruby version after fix: $(ruby -v)"
fi

# Install Bundler
echo "=== Installing Bundler ==="
gem install bundler -v '< 2.0'

# Create directory for the application
echo "=== Creating application directory ==="
mkdir -p ~/apps
cd ~/apps

# Set up the application directory
echo "=== Setting up the application directory ==="
if [ ! -d "daylog" ]; then
  # Check if SOURCE_DIR is provided
  if [ -z "$SOURCE_DIR" ]; then
    # Check if we're running from within the daylog repository
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    if [[ -f "$SCRIPT_DIR/Gemfile" && -d "$SCRIPT_DIR/app" ]]; then
      echo "Running from within the daylog repository. Using current directory as source."
      SOURCE_DIR="$SCRIPT_DIR"
    else
      # Default to /home/daylog/daylog if it exists, otherwise /home/$USER/DayLog
      if [ -d "/home/daylog/daylog" ]; then
        SOURCE_DIR="/home/daylog/daylog"
        echo "No source directory specified. Using default: $SOURCE_DIR"
      elif [ -d "/home/$USER/DayLog" ]; then
        SOURCE_DIR="/home/$USER/DayLog"
        echo "No source directory specified. Using default: $SOURCE_DIR"
      else
        echo "No source directory specified and default locations not found."
        echo "Please provide the path to the DayLog repository:"
        echo "Usage: SOURCE_DIR=/path/to/DayLog ./setup_daylog.sh"
        echo ""
        echo "Or ensure the DayLog repository exists at one of these locations:"
        echo "  /home/daylog/daylog"
        echo "  /home/$USER/DayLog"
        exit 1
      fi
    fi
  fi
  
  # Copy from the source directory
  echo "Copying from $SOURCE_DIR to ~/apps/daylog"
  
  # Check if we're trying to copy into a subdirectory of the source
  DEST_DIR="$HOME/apps/daylog"
  if [[ "$DEST_DIR" == "$SOURCE_DIR"* ]]; then
    echo "ERROR: Cannot copy source directory into itself or its subdirectory."
    echo "Source: $SOURCE_DIR"
    echo "Destination: $DEST_DIR"
    echo "Please run this script from a different location or specify a different SOURCE_DIR."
    exit 1
  fi
  
  cp -r "$SOURCE_DIR" ~/apps/daylog
else
  echo "Directory ~/apps/daylog already exists. Using existing directory."
fi

cd daylog

# Update the launchSite.sh script to use rbenv and bind to 0.0.0.0
echo "=== Updating launch script for rbenv and network binding ==="
if [ -f "scripts/launchSite.sh" ]; then
  cat > scripts/launchSite.sh << 'EOF'
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
EOF
  chmod +x scripts/launchSite.sh
fi

# Install gems
echo "=== Installing gems ==="
bundle install
echo "=== Updating gems to resolve dependency conflicts ==="
bundle update

# Setup the database
echo "=== Setting up the database ==="
echo "Running database migrations..."
bundle exec rake db:migrate RAILS_ENV=production
echo "Setting up database with seed data..."
bundle exec rake db:seed RAILS_ENV=production

# Precompile assets
echo "=== Precompiling assets ==="
bundle exec rake assets:precompile RAILS_ENV=production

# Create a secret key for production
echo "=== Generating secret key ==="
if ! grep -q "secret_key_base" config/secrets.yml; then
  SECRET_KEY=$(bundle exec rake secret)
  echo "production:" >> config/secrets.yml
  echo "  secret_key_base: $SECRET_KEY" >> config/secrets.yml
fi

# Create a systemd service file for automatic startup
echo "=== Creating systemd service ==="
cat > /tmp/daylog.service << EOF
[Unit]
Description=DayLog Rails Application
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/apps/daylog
ExecStart=/bin/bash -lc 'bundle exec rails server -e production -b 0.0.0.0 -p 52553'
Restart=always
Environment=RAILS_ENV=production

[Install]
WantedBy=multi-user.target
EOF

sudo mv /tmp/daylog.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable daylog.service

# Start the service
echo "=== Starting DayLog service ==="
sudo systemctl start daylog.service

echo "=== Setup complete! ==="
echo "DayLog is now running at http://$(hostname -I | awk '{print $1}'):52553"
echo "The application is accessible from any device on your network."
echo "You can manage the service with: sudo systemctl [start|stop|restart|status] daylog.service"

echo ""
echo "=== Application Information ==="
echo "DayLog is a personal tracking application that helps you monitor:"
echo "- Tasks and activities"
echo "- Meals and nutrition"
echo "- Exercise and physical activity"
echo "- Measurements and health metrics"
echo "- Notes and thoughts"
echo ""
echo "The application data is stored in ~/apps/daylog/db/production.sqlite3"
echo "Backups are automatically created in ~/apps/daylog/db/ when migrations are run"
