#
# Cookbook Name:: thumbor
# Recipe:: root_alias_loader
#
# Copyright 2014, CanvasPop / DNA11 <it@canvaspop.com>
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

default['thumbor']['options']['ROOT_ALIAS_LOADER_URLS'] = [
    # '#1#' => 'http://my-secret-bucket.s3.amazon.com/path/to/awesomeness'
    # '#2#' => 'http://example.com'
]

# default['thumbor']['options']['LOADER'] = 'thumbor_root_alias_loader'
