# platform :ios, '9.0'

workspace 'TodoList.xcworkspace'

use_frameworks!

inhibit_all_warnings!

def framework_pods
    pod 'RxSwift'
    pod 'RxCocoa'
end

target 'TodoListApp' do
    project 'TodoListApp/TodoListApp.xcodeproj'
    framework_pods
end

#target 'TodoListAppDB' do
#    project 'TwitSplitCore/TwitSplitCore.xcodeproj'
#end
