require 'github/markup'
require 'liquid'
require "htmlcompressor"
require 'sass'

file = ARGV[0] # File to generate depiction from
name = ARGV[1] # Name of the package
version = ARGV[2] # Version number of the package
bundle = ARGV[3] # Bundle ID of the package

# render markup from input file into html
processed_markdown = GitHub::Markup.render(file, File.read(file))

# read github.css file and minify the css
# github.css is from: https://github.com/sindresorhus/github-markdown-css
engine = Sass::Engine.new(File.read('./depictions/github.css'), :syntax => :scss, :style => :compressed)
compressed_css = engine.render

# read layout file and insert rendered markdown and minified css
template = Liquid::Template.parse(File.read('./depictions/layout.html'))
rendered = template.render({ 'name' => name, 'markdown' => processed_markdown, 'css' => compressed_css})

# minify the html output
compressor = HtmlCompressor::Compressor.new
compressed = compressor.compress(rendered)

# generate an output file from the package bundle and the version number
output_file = './generated_depictions/' << bundle << '_' << version << '.html'

# write output to file
File.write(output_file, compressed)
