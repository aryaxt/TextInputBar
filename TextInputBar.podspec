Pod::Spec.new do |s|
    s.name = 'TextInputBar'
    s.version = '0.1'
    s.summary = 'A keyboard aware and self sizing text input bar'
    s.homepage = 'https://github.com/aryaxt/TextInputBar'
    s.license = {
      :type => 'MIT',
      :file => 'License.txt'
    }
    s.author = {'Aryan Ghassemi' => 'https://github.com/aryaxt/TextInputBar'}
    s.source = {:git => 'https://github.com/aryaxt/TextInputBar.git', :tag => '0.1'}
    s.platform = :ios, '8.0'
    s.source_files = 'TextInputBar/Source/*.{swift}'
    s.framework = 'Foundation', 'UIKit'
    s.requires_arc = true
end
