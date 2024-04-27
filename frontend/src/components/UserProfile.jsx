/**
 * Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import React from "react";
import Typography from "@mui/material/Typography";
import PostCard from "./PostCard";
import ProfilePicture from "../assets/profile-picture.png";

const UserProfile = ({ data }) => {
  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <img
        src={ProfilePicture}
        alt="Profile pic"
        style={{ width: "150px", height: "150px", borderRadius: "50%" }}
      />
      <Typography variant="h2">John Doe</Typography>
      <Typography variant="p">January 1, 1990</Typography>
      <Typography variant="p">123-456-7890</Typography>
      {data.map((item, index) => (
        <PostCard key={index} data={item} />
      ))}
    </div>
  );
};

export default UserProfile;
