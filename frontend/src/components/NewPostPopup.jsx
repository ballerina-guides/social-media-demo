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
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
} from "@mui/material";

const NewPostPopup = ({ open, handleClose, title, children }) => {
  const [description, setDescription] = React.useState("");
  const [category, setCategory] = React.useState("");
  const [hashtags, setHashtags] = React.useState("");

  const handleDescriptionChange = (event) => {
    setDescription(event.target.value);
  };

  const handleCategoryChange = (event) => {
    setCategory(event.target.value);
  };

  const handleHashtagsChange = (event) => {
    setHashtags(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    // Handle the form submission logic here
  };

  return (
    <Dialog open={open} onClose={handleClose} style={{ margin: "20px" }}>
      <DialogTitle style={{ textAlign: "center" }}>{title}</DialogTitle>
      <DialogContent>
        <form onSubmit={handleSubmit}>
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              margin: "20px",
            }}
          >
            <TextField
              label="Description"
              value={description}
              onChange={handleDescriptionChange}
              style={{ margin: "10px", width: "100%" }}
              multiline
              rows={4}
              inputProps={{ maxLength: 250 }}
            />
            <TextField
              label="Category"
              value={category}
              onChange={handleCategoryChange}
              style={{ margin: "10px", width: "100%" }}
            />
            <TextField
              label="Hashtags (comma separated)"
              value={hashtags}
              onChange={handleHashtagsChange}
              style={{ margin: "10px", width: "100%" }}
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
                Discard
              </Button>
              <Button type="submit" color="primary">
                Submit
              </Button>
            </div>
          </DialogActions>
        </form>
      </DialogContent>
    </Dialog>
  );
};

export default NewPostPopup;
