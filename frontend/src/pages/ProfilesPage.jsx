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
import {
  Button,
  Container,
  Box
} from "@mui/material";
import axios from 'axios';

export default function ProfilesPage() {
  const [isPopupOpen, setPopupOpen] = useState(false);
  const [users, setUserNames] = useState([]);

  const deleteUser = (userId) => {
    console.log(`deleted user ${userId}`);

    axios.delete(`http://localhost:9090/social-media/users/${userId}`)
      .then(response => {
        console.log(response)
      }).catch(error => {
        console.error(error);
      }).finally(() => {
        getUsers().then(users => setUserNames(users));
      });
  };

  const addUser = (user) => {
    console.log(`added user ${JSON.stringify(user)}`);

    axios.post(`http://localhost:9090/social-media/users/`, user).
      then(response => {
        console.log(response);
      }).catch(error => {
        console.error(error);
      }).finally(() => {
        getUsers().then(users => setUserNames(users));
        setPopupOpen(false);
      });
  }

  const handlePopupOpen = () => {
    setPopupOpen(true);
  };

  const handlePopupClose = () => {
    setPopupOpen(false);
  };

  useEffect(() => {
    const fetchUsers = async () => {
      setUserNames(await getUsers());
    };

    fetchUsers();
  }, []);

  const getUsers = () => {
    return axios.get('http://localhost:9090/social-media/users')
      .then(response => {
        const users = response.data;
        return users;
      })
      .catch(error => {
        console.error(error);
        return [];
      });
  }

  return (
    <div>
      <Header enableProfile={false} />
      <Box sx={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        minHeight: "75vh",
      }}>
        <Container
          maxWidth="md"
          style={{
            maxHeight: "25rem",
            overflow: 'auto',
            width: "50%",
          }}
          sx={{
            margin: "1rem",
          }}
        >

          {users.map((user, index) => (
            <UserProfileButton key={index} user={user} deleteUser={deleteUser} />
          ))}
        </Container>

        {isPopupOpen && (
          <NewUserPopup
            open={isPopupOpen}
            handleClose={handlePopupClose}
            addUser={addUser}
          />
        )}

        <Button
          variant="contained"
          color="secondary"
          sx={{
            padding: "1rem 2rem",
            borderRadius: "0.5rem",
            color: "white",
            textTransform: "none"
          }}
          onClick={handlePopupOpen}
        >
          Add new user
        </Button>
      </Box>
      <Footer />
    </div>
  );
}
