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
  Box,
} from "@mui/material";
import axios from "axios";
import { useState } from "react";
import CircularProgress from "@mui/material/CircularProgress";
import PostFailurePopup from "./PostFailurePopup";
import { useParams } from "react-router-dom";

const NewPostPopup = ({ open, handleClose, title, refreshPosts }) => {
  const [description, setDescription] = React.useState("");
  const [category, setCategory] = React.useState("");
  const [hashtags, setHashtags] = React.useState("");
  const { id } = useParams();
  const [loading, setLoading] = useState(false);
  const [isOpen, setIsOpen] = useState(false); // State to control the error popup
  const [errorMessage, setErrorMessage] = useState(""); // State to store the error message

  const handleDescriptionChange = (event) => {
    setDescription(event.target.value);
  };

  const handleCategoryChange = (event) => {
    setCategory(event.target.value);
  };

  const handleHashtagsChange = (event) => {
    setHashtags(event.target.value);
  };

  const handleHashtagsKeyDown = (event) => {
    if (event.key === " ") {
      event.preventDefault();
      setHashtags((prevHashtags) => prevHashtags + ", ");
    }
  };

  const [descriptionIsEmpty, setDescriptionIsEmpty] = useState(false);

  const handleSubmit = async (event) => {
    event.preventDefault();
    setDescriptionIsEmpty(!description);
    if (!description) {
      return;
    }
    setLoading(true);
    try {
      await axios.post(`${import.meta.env.VITE_SOCIAL_MEDIA_SERVICE_ENDPOINT}/users/${id}/posts`,
        {
          description: description,
          tags: hashtags.trim(),
          category: category,
        }
      );
      handleClose();
    } catch (error) {
      setErrorMessage(error.message);
      setIsOpen(true);
    } finally {
      refreshPosts();
      setLoading(false);
    }
  };

  return (
    <>
      <PostFailurePopup
        isOpen={isOpen}
        errorMessage={errorMessage}
        handleClose={() => setIsOpen(false)}
      />
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle
          sx={{
            textAlign: "center",
            color: "primary.main",
            fontSize: "26px",
          }}
        >
          {title}
        </DialogTitle>

        <DialogContent>
          <Box
            sx={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              padding: "1rem",
              gap: "1rem",
              width: {
                xs: "15rem",
                md: "30rem",
              },
            }}
          >
            <TextField
              label="Description"
              error={descriptionIsEmpty}
              value={description}
              onChange={handleDescriptionChange}
              fullWidth
              multiline
              rows={4}
              inputProps={{ maxLength: 250 }}
              helperText={`${description.length}/250`}
            />
            <TextField
              label="Category"
              value={category}
              onChange={handleCategoryChange}
              fullWidth
            />
            <TextField
              label="Hashtags (comma separated)"
              value={hashtags}
              onChange={handleHashtagsChange}
              onKeyDown={handleHashtagsKeyDown}
              fullWidth
            />

            <DialogActions
              sx={{
                display: "flex",
                flexDirection: {
                  xs: "column",
                  md: "row",
                },
                justifyContent: "center",
                width: "100%",
                gap: "0.5rem",
              }}
            >
              <Button
                color="secondary"
                sx={{
                  width: {
                    xs: "100%",
                    md: "auto",
                  },
                }}
                size="large"
                onClick={handleClose}
              >
                Discard
              </Button>
              <Button
                variant="contained"
                color="primary"
                sx={{
                  color: "white",
                  width: {
                    xs: "100%",
                    md: "auto",
                  },
                }}
                size="large"
                onClick={handleSubmit}
                disabled={loading}
              >
                {loading ? (
                  <CircularProgress color="inherit" size={24} />
                ) : (
                  "Post"
                )}
              </Button>
            </DialogActions>
          </Box>
        </DialogContent>
      </Dialog>
    </>
  );
};

export default NewPostPopup;
