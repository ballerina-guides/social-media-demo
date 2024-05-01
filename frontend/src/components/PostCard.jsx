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
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import Chip from "@mui/material/Chip";
import Avatar from "@mui/material/Avatar";

export default function PostCard({ data }) {
  const { id, author, description } = data;
  const { tags, category, created_date } = data.meta;

  let hashtagsArr = [];
  if (Array.isArray(tags)) {
    hashtagsArr = tags;
  } else if (typeof tags === "string") {
    hashtagsArr.push(tags);
  }

  return (
    <Card
      sx={{
        width: "100%",
        marginBottom: "1rem",
      }}
    >
      <CardContent>
        <Stack
          direction={"column"}
          gap={"0.5rem"}
          alignItems="baseline"
          justifyContent="space-between"
        >
          <Typography
            gutterBottom
            variant="p"
            component="p"
            sx={{
              wordSpacing: "8px",
            }}
          >
            <Typography
              variant="span"
              component="span"
              sx={{ textTransform: "capitalize" }}
            >
              {author}{" "}
            </Typography>
            &middot; {created_date.year}-{created_date.month}-{created_date.day}
          </Typography>

          <Typography gutterBottom variant="p" component="p">
            {description}
          </Typography>
        </Stack>
        <Stack direction={"row"} gap={"0.5rem"} flexWrap="wrap">
          {category && (
            <Chip
              avatar={<Avatar>C</Avatar>}
              variant="outlined"
              color="primary"
              label={category}
            />
          )}
          {hashtagsArr.map(
            (tag, index) =>
              tag && (
                <Chip
                  key={index}
                  avatar={<Avatar>#</Avatar>}
                  variant="outlined"
                  color="secondary"
                  label={tag}
                />
              )
          )}
        </Stack>
      </CardContent>
    </Card>
  );
}
