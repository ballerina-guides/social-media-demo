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

import { Box, Container, Button } from "@mui/material";
import HeaderLogo from "../assets/logo.png";
import { useNavigate } from "react-router-dom";

export default function Header({ enableProfile }) {
  const navigate = useNavigate();

  return (
    <Box
      sx={{
        borderBottom: "1px solid var(--primary-color)",
        p: 2,
      }}
      backgroundColor="#EEEEEE"
    >
      <Container
        sx={{
          display: "flex",
          flexDirection: {
            xs: "column",
            sm: "row",
          },
          alignItems: "center",
          justifyContent: {
            xs: "center",
            sm: "space-between",
          },
        }}
      >
        <Box
          component="img"
          sx={{
            objectFit: "cover",
            width: "14rem",
            padding: "0.5rem 2rem",
            marginLeft: {
              xs: "0",
              sm: "4rem",
            },
            ":hover": {
              cursor: "pointer",
            },
          }}
          alt="Header logo"
          src={HeaderLogo}
          onClick={() => navigate("/")}
        />
        {
          enableProfile ?
            <Button
              variant="contained"
              color="primary"
              onClick={() => navigate("/profiles")}
              sx={{
                padding: "1rem 2rem",
                borderRadius: "1rem",
                color: "white",
              }}
            >
              Profiles
            </Button> : ""
        }
      </Container>
    </Box>
  );
}
