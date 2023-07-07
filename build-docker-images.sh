#!/usr/bin/env bash
# Copyright 2023 WSO2 LLC. (http://wso2.com)
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
( cd sts_service ; bal clean ; bal build)
( cd sentiment_api_secured ; bal clean ; bal build)
( cd notification_hub ; bal clean ; bal build)
( cd social_media ; bal clean ; bal build)
( cd slack_message_sender ; bal clean ; bal build)
( cd social_media_notification ; bal clean ; bal build)
