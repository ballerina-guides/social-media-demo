import React from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogContentText,
  DialogActions,
  Button,
} from "@mui/material";

const PostFailurePopup = ({ isOpen, errorMessage, handleClose }) => {
  return (
    <Dialog
      open={isOpen}
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle
        sx={{
          textAlign: "center",
          color: "red",
          fontSize: "20px",
        }}
        id="alert-dialog-title"
      >
        {"Failed to post"}
      </DialogTitle>
      <DialogContent>
        <DialogContentText id="alert-dialog-description" sx={{ textAlign: "center" }}>
          {errorMessage}
        </DialogContentText>
      </DialogContent>
      <DialogActions
        sx={{
          display: "flex",
          flexDirection: {
            xs: "column",
            md: "row",
          },
          justifyContent: "center",
          width: "auto",
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
          onClick={handleClose}
          autoFocus
        >
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default PostFailurePopup;
