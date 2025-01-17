#!/usr/bin/env bash

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

default_config() {
  left_icon="☺ "
  show_fahrenheit=true

  $current_dir/sleep_weather.sh $show_fahrenheit &

  # sets refresh interval to every 5 seconds
  tmux set-option -g status-interval 5

  # set clock to 12 hour by default
  tmux set-option -g clock-mode-style 12

  # set length 
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # show border contrast by default
  tmux set-option -g pane-active-border-style "fg=${light_purple}"
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"


  tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon}"
  tmux set-option -g  status-right ""

  battery
  network
  weather
  clock

  tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "
}

battery() {
  tmux set-option -g  status-right "#[fg=${dark_gray},bg=${pink}] #($current_dir/battery.sh) "
}

cpu() {
  tmux set-option -ga status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/cpu_info.sh) "
}

network() {
  tmux set-option -ga status-right "#[fg=${dark_gray},bg=${cyan}] #($current_dir/network.sh) "
}

weather() {
  tmux set-option -ga status-right "#[fg=${dark_gray},bg=${orange}] #(cat $current_dir/../data/weather.txt) "
}

military() {
  tmux set-option -ga status-right "#[fg=${white},bg=${dark_purple}] %a %m/%d %R #(date +%Z) "
}

clock() {
  tmux set-option -ga status-right "#[fg=${white},bg=${dark_purple}] %a %m/%d %I:%M %p #(date +%Z) "
}

battery_powerline() {
  tmux set-option -g  status-right "#[fg=${pink},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${pink}] #($current_dir/battery.sh)"
  powerbg=${pink}
}

cpu_powerline() {
  tmux set-option -ga status-right "#[fg=${orange},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${orange}] #($current_dir/cpu_info.sh)"
	powerbg=${orange}
}

network_powerline() {
  tmux set-option -ga status-right "#[fg=${cyan},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${cyan}] #($current_dir/network.sh)"
  powerbg=${cyan}
}

weather_powerline() {
  tmux set-option -ga status-right "#[fg=${orange},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${orange}] #(cat $current_dir/../data/weather.txt)"
  powerbg=${orange}
}

military_powerline() {
  tmux set-option -ga status-right "#[fg=${dark_purple},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${white},bg=${dark_purple}] %a %m/%d %R #(date +%Z) "
}

clock_powerline() {
  tmux set-option -ga status-right "#[fg=${dark_purple},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${white},bg=${dark_purple}] %a %m/%d %I:%M %p #(date +%Z) "
}
main()
{
  # set current directory variable
  current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  # set defaults for configuration option variables
  show_battery=$(get_tmux_option "@dracula-show-battery" true)
  show_network=$(get_tmux_option "@dracula-show-network" true)
  show_weather=$(get_tmux_option "@dracula-show-weather" true)
  show_fahrenheit=$(get_tmux_option "@dracula-show-fahrenheit" true)
  show_powerline=$(get_tmux_option "@dracula-show-powerline" false)
  show_left_icon=$(get_tmux_option "@dracula-show-left-icon" smiley)
  show_military=$(get_tmux_option "@dracula-military-time" false)
  show_left_sep=$(get_tmux_option "@dracula-show-left-sep" )
  show_right_sep=$(get_tmux_option "@dracula-show-right-sep" )
  show_border_contrast=$(get_tmux_option "@dracula-border-contrast" false)
  show_cpu_percentage=$(get_tmux_option "@dracula-cpu-percent" false)
  

  # config_list=$(tmux show-option -gqv "@dracula-config-list")
  # if [ -z $config_list ]; then
  #   default_config
  # fi

  # for opt in $config_list
  # do
  #   echo $opt
  # done 

  # Dracula Color Pallette
  white='#f8f8f2'
  gray='#44475a'
  dark_gray='#282a36'
  light_purple='#bd93f9'
  dark_purple='#6272a4'
  cyan='#8be9fd'
  green='#50fa7b'
  orange='#ffb86c'
  red='#ff5555'
  pink='#ff79c6'
  yellow='#f1fa8c'
  

  # Handle left icon configuration
  case $show_left_icon in
      smiley)
          left_icon="☺ ";;
      session)
          left_icon="#S ";;
      window)
	        left_icon="#W ";;
      *)
          left_icon=$show_left_icon;;
  esac

  # Handle powerline option
  if $show_powerline; then
      right_sep="$show_right_sep"
      left_sep="$show_left_sep"
  fi

  # start weather script in background
  if $show_weather; then
    $current_dir/sleep_weather.sh $show_fahrenheit &
  fi
  
  # sets refresh interval to every 5 seconds
  tmux set-option -g status-interval 5

  # set clock to 12 hour by default
  tmux set-option -g clock-mode-style 12

  # set length 
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  if $show_border_contrast; then
    tmux set-option -g pane-active-border-style "fg=${light_purple}"
  else
    tmux set-option -g pane-active-border-style "fg=${dark_purple}"
  fi
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"


  # Powerline Configuration
  if $show_powerline; then

      tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon} #[fg=${green},bg=${gray}]#{?client_prefix,#[fg=${yellow}],}${left_sep}"
      tmux set-option -g  status-right ""
      powerbg=${gray}

      if $show_battery; then # battery
        battery_powerline
      fi

      if $show_cpu_percentage; then
        cpu_powerline
      fi

      if $show_network; then # network
        network_powerline
      fi

      if $show_weather; then # weather
        weather_powerline
      fi

      if $show_military; then # military time
        military_powerline
      else
        clock_powerline
      fi

      tmux set-window-option -g window-status-current-format "#[fg=${gray},bg=${dark_purple}]${left_sep}#[fg=${white},bg=${dark_purple}] #I #W #[fg=${dark_purple},bg=${gray}]${left_sep}"
  
  # Non Powerline Configuration
  else
    tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon}"

    tmux set-option -g  status-right ""

      if $show_battery; then # battery
        battery
      fi

      if $show_cpu_percentage; then
        cpu
      fi

      if $show_network; then # network
        network
      fi

      if $show_weather; then # weather
          weather
      fi

      if $show_military; then # military time
        military
      else
        clock
      fi

      tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "

  fi
  
  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W "
}

# run main function
main
