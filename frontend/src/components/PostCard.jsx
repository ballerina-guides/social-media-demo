import React from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import Chip from "@mui/material/Chip";
import Avatar from "@mui/material/Avatar";

const PostCard = ({ data }) => {
  const { id, description, meta } = data;
  const { tags, category, created_date } = meta;

  let hashtagsArr = [];
  if (Array.isArray(tags)) {
    hashtagsArr = tags;
  } else if (typeof tags === "string") {
    hashtagsArr = [tags];
  }

  return (
    <Card
      sx={{
        width: "100%",
        ":hover": {
          cursor: "pointer",
          background: "var(--primary-color-light1)",
        },
        marginBottom: "1rem",
      }}
    >
      <CardContent>
        <Stack
          direction={"column"}
          gap={"0.5rem"}
          alignItems="baseline"
          justifyContent="space-between"
        >
          <Stack
            direction={"row"}
            gap={"0.5rem"}
            alignItems="baseline"
            justifyContent="space-between"
          >
            <Typography gutterBottom variant="p" component="p">
              {/* {author} */} author?
            </Typography>
            <Typography gutterBottom variant="p" component="p">
              {String.fromCharCode(183)}
            </Typography>
            <Typography gutterBottom variant="p" component="p">
              {created_date.toLocaleDateString()}
            </Typography>
          </Stack>
          <Typography gutterBottom variant="p" component="p">
            {description}
          </Typography>
        </Stack>
        <Chip
          avatar={<Avatar>C</Avatar>}
          variant="outlined"
          color="primary"
          label={category}
        />
        {hashtagsArr.map((tag, index) => (
          <Chip
            key={index}
            avatar={<Avatar>#</Avatar>}
            variant="outlined"
            color="secondary"
            label={tag}
          />
        ))}
      </CardContent>
    </Card>
  );
};

export default PostCard;
