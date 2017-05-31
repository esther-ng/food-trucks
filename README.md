# Show Open Food Trucks

A Mac OSX command line program to print a list of food trucks open at runtime. Bon Appetit!

## Dependencies

- [Ruby](https://www.ruby-lang.org/en/)
- [formatador](https://github.com/geemus/formatador) (for outputting table of food truck names and addresses)

Max OSX comes with Ruby preinstalled. You can check which version you have installed by typing ```ruby -v```. If you do not have Ruby installed, follow the link above to download and install Ruby.

To install formatador:
  1. ```gem install formatador```
  2. If you clone this repository and have bundler installed, you can also use ```bundle install```

## Set Up & Usage

### Building from Source
  1. Clone this repository ```git clone https://github.com/esther-ng/food-trucks.git```
  2. Install formatador (see above)
  3. ```./show-open-food-trucks.rb``` (set up a bash alias if desired)
  4. Follow the prompts

### Just Give Me the Food Trucks
  1. Navigate to the releases page of this repository
  2. Download the ```show-open-food-trucks``` file to your ```usr/local/bin``` directory
  3. From that directory run ```chmod 755 show-open-food-trucks ```
  3. ```gem install formatador```
  4. ```show-open-food-trucks```
  5. Follow the prompts
 
### Notes on Throttling
If you receive an error message that your usage has been throttled, you may raise your limits by requesting a [San Francisco Data API App Token](https://dev.socrata.com/foundry/data.sfgov.org/bbb8-hzi6) and utilizing the commented out code on line 54 of the source code.
