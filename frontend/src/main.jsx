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
import { createRoot } from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { ThemeProvider } from "@emotion/react";
import { createTheme } from "@mui/material";
import "@fontsource/quicksand";

const theme = createTheme({
  palette: {
    mode: "light",
    primary: {
      main: "#20b6b0",
    },
    secondary: {
      main: "#464646",
    },
  },
  typography: {
    fontFamily: ["quicksand", "sans-serif"].join(","),
    h1: {
      fontSize: "38px",
    },
    h2: {
      fontSize: "32px",
    },
    h3: {
      fontSize: "29px",
    },
    h4: {
      fontSize: "21px",
    },
    h5: {
      fontSize: "16px",
    },
    h6: {
      fontSize: "16px",
    },
    p: {
      fontSize: "16px",
    },
  },
});

const root = createRoot(document.getElementById("root"));

root.render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <App />
    </ThemeProvider>
  </React.StrictMode>
);
