# platform :ios, '9.0'

workspace 'TodoList.xcworkspace'

use_frameworks!

inhibit_all_warnings!

def framework_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RealmSwift', '~> 3.20.0'
end

target 'TodoListApp' do
    project 'TodoListApp/TodoListApp.xcodeproj'
    framework_pods
end

target 'TodoListAppTests' do
    project 'TodoListApp/TodoListApp.xcodeproj'
    pod 'RealmSwift'
end
