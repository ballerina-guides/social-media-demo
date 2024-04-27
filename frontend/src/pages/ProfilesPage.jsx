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
import Footer from "../components/Footer";
import Header from "../components/Header";
import UserProfileButton from "../components/UserProfileButton";
import { Stack, Button, Container } from "@mui/material";

export default function ProfilesPage() {

  const data = ["Hamilton", "Verstappen", "Norris", "Maryam"];
  return (
    <div>
      <Header enableProfile={false} />
      <Stack sx={{
        justifyContent: "center",
        display: "flex",
        alignItems: "center",
      }}>
        <Stack>
          {data.map((name, index) => (
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
        >
          Add new user
        </Button>
      </Stack>
      <Footer />
    </div>
  );
}
