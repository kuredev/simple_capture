# SimpleCapture

Packet capture tool made only with Ruby

![simple_capture3-3](https://user-images.githubusercontent.com/1259315/108730552-fd36a000-756e-11eb-88a0-2b7244802050.gif)

## Installation

```
% gem install simple_capture
```

## Usage

### Create a file for test execution

```
% vim test.rb
```

test.rb
```ruby
require "simple_capture"

cap = SimpleCapture::Capture.new("eth1")
cap.run
```

### Execute

```
% sudo ruby test.rb 
```
