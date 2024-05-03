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
import dayjs from 'dayjs';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  Box,
} from "@mui/material";
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';

const NewUserPopup = ({ open, handleClose, addUser }) => {
  const [userName, setUserName] = React.useState("");
  const [dateOfBirth, setDOB] = React.useState(dayjs('2022-04-17').toDate());
  const [mobileNumber, setMobileNumber] = React.useState("");
  const [userNameIsEmpty, setUserNameIsEmpty] = React.useState(false);
  const [mobileNumberIsEmpty, setMobileNumberIsEmpty] = React.useState(false);

  const handleUserNameChange = (event) => {
    setUserNameIsEmpty(false);
    setUserName(event.target.value);
  };

  const handleDOBChange = (newValue) => {
    const dob = new Date(newValue);
    setDOB(dob);
  };

  const handleMobileNumberChange = (event) => {
    setMobileNumberIsEmpty(false);
    setMobileNumber(event.target.value);
  };

  const handleSubmit = () => {
    setUserNameIsEmpty(!userName);
    setMobileNumberIsEmpty(!mobileNumber);
    if (!userName || !dateOfBirth || !mobileNumber) {
      return;
    }
    addUser(getUser());
  };

  const getUser = () => {
    return {
      name: userName,
      birthDate: {
        year: dateOfBirth.getFullYear(),
        month: dateOfBirth.getMonth() + 1,
        day: dateOfBirth.getDate()
      },
      mobileNumber: mobileNumber
    };
  };

  return (
    <Dialog open={open} onClose={handleClose}>
      <DialogTitle sx={{
        textAlign: "center",
        color: "primary.main",
        fontSize: "26px"
      }}>Add new user</DialogTitle>

      <DialogContent>
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            padding: "1rem",
            gap: "1rem",
            width: {
              xs: "14rem",
              md: "30rem",
            }
          }}
        >
          <TextField
            error={userNameIsEmpty}
            label="User Name:"
            value={userName}
            onChange={handleUserNameChange}
            fullWidth
          />

          <LocalizationProvider dateAdapter={AdapterDayjs}>
            <DatePicker
              label="Date of Birth:"
              value={dayjs(dateOfBirth)}
              onChange={handleDOBChange}
            />
          </LocalizationProvider>

          <TextField
            error={mobileNumberIsEmpty}
            label="Mobile Number:"
            value={mobileNumber}
            type="number"
            onChange={handleMobileNumberChange}
            fullWidth
          />

          <DialogActions
            sx={{
              display: "flex",
              justifyContent: "center",
              flexDirection: {
                xs: "column",
                md: "row",
              },
              gap: "0.5rem",
              width: "100%"
            }}
          >
            <Button
              color="secondary"
              sx={{
                width: {
                  xs: "100%",
                  md: "auto",
                }
              }}
              size="large"
              onClick={handleClose}
            >
              Cancel
            </Button>
            <Button
              variant="contained"
              color="primary"
              sx={{
                color: "white",
                width: {
                  xs: "100%",
                  md: "auto",
                }
              }}
              size="large"
              onClick={handleSubmit}
            >
              Add User
            </Button>
          </DialogActions>
        </Box>
      </DialogContent>
    </Dialog>
  );
};

export default NewUserPopup;
