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
} from "@mui/material";
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';

const NewUserPopup = ({ open, handleClose, addUser }) => {
  const [userName, setUserName] = React.useState("");
  const [dateOfBirth, setDOB] = React.useState(dayjs('2022-04-17').toDate());
  const [mobileNumber, setMobileNumber] = React.useState("");

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

  const handleUserNameChange = (event) => {
    setUserName(event.target.value);
  };

  const handleDOBChange = (newValue) => {
    const dob = new Date(newValue);
    console.log(dob.getDate());
    setDOB(dob);
  };

  const handleMobileNumberChange = (event) => {
    setMobileNumber(event.target.value);
  };

  const handleAddNewUser = (event) => {
    event.preventDefault();
  };

  return (
    <Dialog open={open} onClose={handleClose} style={{ margin: "20px" }}>
      <DialogTitle style={{ textAlign: "center" }}>
        Add new user
      </DialogTitle>
      <DialogContent>
        <form onSubmit={handleAddNewUser}>
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "start",
              margin: "20px",
              gap: "20px",
              width: "30rem",
            }}
          >
            <TextField
              label="User Name:"
              value={userName}
              onChange={handleUserNameChange}
              style={{ width: "100%" }}
            />
            <LocalizationProvider dateAdapter={AdapterDayjs}
              style={{ width: "100%" }}
            >
              <DatePicker
                label="Date of Birth:"
                style={{ width: "100%" }}
                value={dayjs(dateOfBirth)}
                onChange={handleDOBChange}
              />
            </LocalizationProvider>
            <TextField
              label="Mobile Number:"
              value={mobileNumber}
              type="number"
              onChange={handleMobileNumberChange}
              style={{ width: "100%" }}
            />
          </div>
          <DialogActions>
            <div
              style={{
                display: "flex",
                justifyContent: "center",
                margin: "20px",
              }}
            >
              <Button onClick={handleClose} color="secondary">
                Cancel
              </Button>
              <Button
                type="submit"
                color="primary"
                onClick={() => addUser(getUser())}
              >
                Add User
              </Button>
            </div>
          </DialogActions>
        </form>
      </DialogContent>
    </Dialog>
  );
};

export default NewUserPopup;
