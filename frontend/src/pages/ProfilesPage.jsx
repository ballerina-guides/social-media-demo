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

import React, { useEffect, useState } from "react";
import Footer from "../components/Footer";
import Header from "../components/Header";
import UserProfileButton from "../components/UserProfileButton";
import NewUserPopup from "../components/NewUserPopup";
import { Stack, Button, Box } from "@mui/material";
import axios from 'axios';

export default function ProfilesPage() {
  const [isPopupOpen, setPopupOpen] = useState(false);
  const [userNames, setUserNames] = useState(["Hamilton", "Verstappen", "Norris", "Maryam", "Hamilton", "Verstappen", "Norris", "Maryam", "Hamilton", "Verstappen", "Norris", "Maryam"]);

  const handlePopupOpen = () => {
    setPopupOpen(true);
  };

  const handlePopupClose = () => {
    setPopupOpen(false);
  };

  useEffect(() => {
    const fetchUsers = async () => {
      const userNames = await getUsers();
      setUserNames(userNames);
    };

    fetchUsers();
  }, []);

  const getUsers = () => {
    return axios.get('http://localhost:9090/social-media/users')
      .then(response => {
        const users = response.data;
        return users.map(user => user.name);
      })
      .catch(error => {
        console.error(error);
      });
  }

  // const userNames = getUsers();
  return (
    <div>
      <Header enableProfile={false} />
      <Stack sx={{
        justifyContent: "center",
        display: "flex",
        alignItems: "center",
      }}>
        <Stack
          style={{
            maxHeight: "25rem",
            overflow: 'auto',
            width: "50%",
          }}>

          {userNames.map((name, index) => (
            <UserProfileButton key={index} userName={name} />
          ))}
        </Stack>

        <Button
          variant="contained"
          color="secondary"
          sx={{
            padding: "1rem 2rem",
            margin: "0.5rem",
            borderRadius: "1rem",
            color: "white",
          }}
          onClick={handlePopupOpen}
        >
          Add new user
        </Button>
      </Stack>
      <Footer />
      {isPopupOpen && (
        <NewUserPopup
          open={isPopupOpen}
          handleClose={handlePopupClose}
          title="Add new user"
        />
      )}
    </div>
  );
}
