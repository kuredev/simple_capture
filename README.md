# SimpleCapture

Packet capture tool made only with Ruby

![simple_capture3](https://user-images.githubusercontent.com/1259315/108729134-91a00300-756d-11eb-870c-2a51a3b1fb27.gif)


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
