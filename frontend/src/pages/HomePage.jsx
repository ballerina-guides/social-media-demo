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
import UserProfile from "../components/UserProfile";
import NewPostPopup from "../components/NewPostPopup";
import Fab from "@mui/material/Fab";
import AddIcon from "@mui/icons-material/Add";
import axios from "axios";
import { Container } from "@mui/material";

function CustomTabPanel(props) {
  const {
    children,
    value,
    index,
    other } = props;

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
          {children}
        </Box>
      )}
    </div>
  );
}

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`,
  };
}

export default function HomePage() {
  const [value, setValue] = useState(0);
  const [posts, setPosts] = useState([]);
  const [userPosts, setUserPosts] = useState([]);
  const userData = {
    name: "Ranga Doe",
    birthday: "01/01/1990",
    mobileNumber: "1234567890",
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(
          "http://localhost:9090/social-media/posts"
        );
        setPosts(response.data);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(
          // TODO: get user details from a variable
          "http://localhost:9090/social-media/users/1/posts"
        );
        setUserPosts(response.data);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  // New Post
  const [isPopupOpen, setPopupOpen] = useState(false);

  const handlePopupOpen = () => {
    setPopupOpen(true);
  };

  const handlePopupClose = () => {
    setPopupOpen(false);
  };

  return (
    <Box>
      <Header enableProfile={true} />
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

        <CustomTabPanel value={value} index={0}>
          <Container>
            {posts.map((item, index) => (
              <PostCard key={index} data={item} />
            ))}
          </Container>
        </CustomTabPanel>

        <CustomTabPanel value={value} index={1}>
          <Container>
            <UserProfile data={{ userPosts, userData }} />
          </Container>
        </CustomTabPanel>
      </Box>

      {isPopupOpen && (
        <NewPostPopup
          open={isPopupOpen}
          handleClose={handlePopupClose}
          title="New Post"
        />
      )}

      <Fab
        color="primary"
        aria-label="add"
        sx={{ position: "fixed", bottom: "20px", right: "20px", color: "white" }}
        onClick={handlePopupOpen}
      >
        <AddIcon />
      </Fab>

      <Footer />
    </Box>
  );
}
