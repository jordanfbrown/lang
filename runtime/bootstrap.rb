Constants = {}
Constants["Class"] = AwesomeClass.new
# Class.class = Class
Constants["Class"].runtime_class = Constants["Class"]
Constants["Object"] = AwesomeClass.new
Constants["Number"] = AwesomeClass.new(Constants["Object"])
Constants["String"] = AwesomeClass.new(Constants["Object"])
Constants["TrueClass"] = AwesomeClass.new(Constants["Object"])
Constants["FalseClass"] = AwesomeClass.new(Constants["Object"])
Constants["NilClass"] = AwesomeClass.new(Constants["Object"])
Constants["true"] = Constants["TrueClass"].new_with_value(true)
Constants["false"] = Constants["FalseClass"].new_with_value(false)
Constants["nil"] = Constants["NilClass"].new_with_value(nil)

root_self = Constants["Object"].new
RootContext = Context.new(root_self)

Constants["Class"].def(:new) do |receiver, arguments|
  receiver.new
end

Constants["Object"].def(:print) do |receiver, arguments|
  puts arguments.first.ruby_value
  Constants["nil"]
end

Constants["Object"].def(:inspect) do |receiver, arguments|
  puts "\"#{receiver.ruby_value}\""
  receiver
end

[:+, :-, :/, :*].each do |operation|
  Constants["Number"].def(operation) do |receiver, arguments|
    result = receiver.ruby_value.send(operation, arguments.first.ruby_value)
    Constants["Number"].new_with_value(result)
  end
end


