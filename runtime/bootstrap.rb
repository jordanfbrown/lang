Constants = {}
Constants["Class"] = AwesomeClass.new
# Class.class = Class
Constants["Class"].runtime_class = Constants["Class"]
Constants["Object"] = AwesomeClass.new
Constants["Number"] = AwesomeClass.new
Constants["String"] = AwesomeClass.new
Constants["TrueClass"] = AwesomeClass.new
Constants["FalseClass"] = AwesomeClass.new
Constants["NilClass"] = AwesomeClass.new
Constants["true"] = Constants["TrueClass"].new_with_value(true)
Constants["false"] = Constants["FalseClass"].new_with_value(true)
Constants["nil"] = Constants["NilClass"].new_with_value(true)

root_self = Constants["Object"].new
RootContext = Context.new(root_self)

Constants["Class"].def(:new) do |receiver, arguments|
  receiver.new
end

Constants["Object"].def(:print) do |receiver, arguments|
  puts arguments.first.ruby_value
  Constants["nil"]
end


