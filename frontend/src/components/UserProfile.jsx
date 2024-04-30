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
import { Box, IconButton, Stack } from "@mui/material";
import DateRange from "@mui/icons-material/DateRange";
import Phone from "@mui/icons-material/Phone";

const UserProfile = ({ data }) => {
  const { name, birthDate, mobileNumber } = data.userData;
  const { userPosts } = data;

  return (
    <Box
      sx={{
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

      <Box
        alignItems="center"
        sx={{
          display: "flex",
          flexDirection: "column",
        }}
      >
        <Typography variant="h2" sx={{ textTransform: "capitalize" }} >{name}</Typography>

        <Stack
          direction="row"
          alignItems="center"
        >
          <IconButton color="primary">
            <DateRange fontSize="medium" color="secondary" />
          </IconButton>
          <Typography variant="p" color="primary">
            {birthDate.year}-{birthDate.month}-{birthDate.day}
          </Typography>
        </Stack>

        <Stack
          direction="row"
          alignItems="center"
        >
          <IconButton color="primary">
            <Phone fontSize="medium" color="secondary" />
          </IconButton>
          <Typography variant="p" color="primary">
            {mobileNumber}
          </Typography>
        </Stack>
      </Box>

      {userPosts.map((item, index) => (
        <PostCard key={index} data={item} />
      ))}
    </Box>
  );
};

export default UserProfile;
