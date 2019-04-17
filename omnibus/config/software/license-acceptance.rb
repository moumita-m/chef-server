#
# Copyright 2012-2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "license-acceptance"
default_version "master"

license "Apache-2.0"
license_file "http://www.apache.org/licenses/LICENSE-2.0"
#license_file "https://github.com/chef/license-acceptance/blob/master/LICENSE"

skip_transitive_dependency_licensing true

source git: "git@github.com:chef/license-acceptance.git"


dependency "ruby"
dependency "rubygems"
dependency "bundler"

# the gem lives in  "components/ruby"
build do

  dir = "#{project_dir}/components/ruby"

  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install --without development test", cwd: dir, env: env

  gem "build license-acceptance.gemspec", cwd: dir, env: env
  gem "install license-acceptance-*.gem", cwd: dir, env: env
end
