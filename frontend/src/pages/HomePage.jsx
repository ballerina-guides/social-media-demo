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

import React, { useState, useEffect } from "react";
import Footer from "../components/Footer";
import Header from "../components/Header";
import PropTypes from "prop-types";
import Tabs from "@mui/material/Tabs";
import Tab from "@mui/material/Tab";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import PostCard from "../components/PostCard";

function CustomTabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 2 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

CustomTabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`,
  };
}

export default function HomePage() {
  const dummyData = [
    {
      id: 1,
      description: "Post 1 description",
      meta: {
        tags: ["tag1", "tag2"],
        category: "Category1",
        created_date: new Date(),
      },
    },
    {
      id: 2,
      description: "Post 2 description",
      meta: {
        tags: ["tag3", "tag4"],
        category: "Category2",
        created_date: new Date(),
      },
    },
    {
      id: 3,
      description: "Post 3 description",
      meta: {
        tags: ["tag5", "tag6"],
        category: "Category3",
        created_date: new Date(),
      },
    },
  ];

  const [data] = useState(dummyData);

  const [value, setValue] = React.useState(0);
  // const [data, setData] = useState([]);

  // useEffect(() => {
  //   fetch("<<bal endpoint here>>")
  //     .then((response) => response.json())
  //     .then((data) => setData(data));
  // }, []);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <div>
      <Header />
      <Box
        sx={{
          width: "100%",
          borderBottom: 1,
          borderColor: "divider",
          justifyContent: "center",
        }}
      >
        <Tabs
          value={value}
          onChange={handleChange}
          sx={{
            display: "flex",
            width: "100%",
          }}
        >
          <Tab
            sx={{
              flex: 1,
              minWidth: 0,
              maxWidth: "50%",
            }}
            label="Posts"
            {...a11yProps(0)}
          />
          <Tab
            sx={{
              flex: 1,
              minWidth: 0,
              maxWidth: "50%",
            }}
            label="Profile"
            {...a11yProps(1)}
          />
        </Tabs>
      </Box>
      <CustomTabPanel value={value} index={0}>
        {data.map((item, index) => (
          <PostCard key={index} data={item} />
        ))}
      </CustomTabPanel>
      <CustomTabPanel value={value} index={1}>
        Profile here
      </CustomTabPanel>
      <Footer />
    </div>
  );
}
