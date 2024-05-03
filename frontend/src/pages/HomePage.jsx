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
import Tabs from "@mui/material/Tabs";
import Tab from "@mui/material/Tab";
import Box from "@mui/material/Box";
import PostCard from "../components/PostCard";
import NewPostPopup from "../components/NewPostPopup";
import Error from "../components/Error";
import Fab from "@mui/material/Fab";
import AddIcon from "@mui/icons-material/Add";
import axios from "axios";
import { Container, Typography } from "@mui/material";

function CustomTabPanel(props) {
  const { children, value, index, other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && <Box sx={{ p: 2 }}>{children}</Box>}
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
  const [postsFetchError, setPostsFetchError] = useState(false);

  const fetchAllPosts = async () => {
    try {
      const response = await axios.get(`${import.meta.env.VITE_SOCIAL_MEDIA_SERVICE_ENDPOINT}/posts`);
      setPosts(response.data);
    } catch (error) {
      console.error("Error fetching data:", error);
      setPostsFetchError(true);
    }
  };

  useEffect(() => {
    fetchAllPosts();
    const intervalId = setInterval(fetchAllPosts, 5000);
    return () => clearInterval(intervalId);
  }, []);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

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
          minHeight: "75vh",
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
              maxWidth: "100%",
            }}
            label="Posts"
            onClick={fetchAllPosts}
            {...a11yProps(0)}
          />
        </Tabs>

        <CustomTabPanel value={value} index={0}>
          {postsFetchError ? <Error errorMessage={"Failed to Fetch Posts"} /> :
            <Container
              style={{
                display: "flex",
                flexDirection: "column",
                justifyContent: "center",
                alignItems: "center",
              }}
            >
              {posts.length === 0 ? (
                <Typography sx={{ margin: "1rem" }}>
                  {"No posts to display :("}
                </Typography>
              ) : (
                posts.map((item, index) => <PostCard key={index} data={item} />)
              )}
            </Container>
          }
        </CustomTabPanel>
      </Box>
      {isPopupOpen && (
        <NewPostPopup
          open={isPopupOpen}
          handleClose={handlePopupClose}
          title="New Post"
          refreshPosts={fetchAllPosts}
        />
      )}

      <Fab
        color="primary"
        aria-label="add"
        sx={{
          position: "fixed",
          bottom: "20px",
          right: "20px",
          color: "white",
          display: "auto",
        }}
        onClick={handlePopupOpen}
      >
        <AddIcon />
      </Fab>

      <Footer />
    </Box>
  );
}
