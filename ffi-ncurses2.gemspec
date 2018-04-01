# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'ffi-ncurses/version'

date         = "2018-04-01"
authors      = ["Sean O'Halpin"]
email        = "sean.ohalpin@gmail.com"
project      = FFI::NCurses
description  = "Fork of ffi-ncurses fixed for working on modern (2.x) Ruby versions, and the multi_progress_bar gem."
dependencies = [
                ["ffi", ">= 1.0.9"],
                ["ffi-locale", ">= 1.0.0"],
               ]

Gem::Specification.new do |s|
  s.authors     = authors
  s.email       = email
  s.date        = date
  s.description = description
  dependencies.each do |dep|
    s.add_dependency *dep
  end
  s.files =
    [
     "#{project::NAME}.gemspec",
     "lib/ffi-ncurses.rb",
     "COPYING",
     "History.txt",
     "README.rdoc",
     "Rakefile",
     "Gemfile",
     "Gemfile.lock",
    ] +
    Dir["examples/**/*"] +
    Dir["lib/**/*.rb"] +
    Dir["spec/**/*.rb"]

  s.name          = project::NAME
  s.version       = project::VERSION
  s.homepage      = "https://github.com/saveriomiroddi/#{project::NAME}"
  s.summary       = s.description
  s.require_paths = ["lib"]
end
