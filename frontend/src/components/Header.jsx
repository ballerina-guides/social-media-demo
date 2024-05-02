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

import { Box, Container, Button, Stack, IconButton } from "@mui/material";
import HeaderLogo from "../assets/logo.png";
import { useNavigate, useParams } from "react-router-dom";
import Person from "@mui/icons-material/Person";

export default function Header({ enableProfile = false }) {
  const navigate = useNavigate();
  const { id } = useParams();

  return (
    <Box
      sx={{
        borderBottom: "1px solid var(--primary-color)",
      }}
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
            width: "13rem",
            padding: "0.5rem 2rem",
          }}
          alt="Header logo"
          src={HeaderLogo}
          style={{ cursor: "pointer" }}
          onClick={() => window.location.reload()}
        />
        {id ? (
          <Stack direction="row" gap="1rem">
            {enableProfile ?
              <IconButton
                color="primary"
                onClick={() => navigate(`/user/${id}/profile`)}
              >
                <Person fontSize="large" color="secondary" />
              </IconButton> :
              <Button
                variant="contained"
                color="primary"
                onClick={() => navigate(`/user/${id}`)}
                sx={{
                  padding: "1rem 2rem",
                  borderRadius: "0.5rem",
                  color: "white",
                  textTransform: "none",
                }}
              >
                Home
              </Button>
            }
            <Button
              variant="contained"
              color="primary"
              onClick={() => navigate(`/`)}
              sx={{
                padding: "1rem 2rem",
                borderRadius: "0.5rem",
                color: "white",
                textTransform: "none",
              }}
            >
              Switch Profile
            </Button>
          </Stack>
        ) : (
          ""
        )}
      </Container>
    </Box>
  );
}
