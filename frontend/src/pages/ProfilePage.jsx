import {
  Box,
  Container,
  Divider,
  IconButton,
  Stack,
  Typography,
} from "@mui/material";
import PostCard from "../components/PostCard";
import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import Header from "../components/Header";
import ProfilePicture from "../assets/profile-picture.png";
import DateRange from "@mui/icons-material/DateRange";
import Phone from "@mui/icons-material/Phone";
import axios from "axios";
import Error from "../components/Error";
import Footer from "../components/Footer";

export default function ProfilePage() {
  const [userData, setUserData] = useState([]);
  const [userPosts, setUserPosts] = useState([]);
  const { id } = useParams();
  const [userFetchError, setUserFetchError] = useState(false);
  const [userPostsFetchError, setUserPostsFetchError] = useState(false);

  const fetchUserData = async () => {
    try {
      const response = await axios.get(`${import.meta.env.VITE_SOCIAL_MEDIA_SERVICE_ENDPOINT}/users/${id}`);
      setUserData(response.data);
    } catch (error) {
      console.error("Error fetching data:", error);
      setUserFetchError(true);
    }
  };

  const fetchUserPosts = async () => {
    try {
      const response = await axios.get(`${import.meta.env.VITE_SOCIAL_MEDIA_SERVICE_ENDPOINT}/users/${id}/posts`);
      setUserPosts(response.data);
    } catch (error) {
      console.error("Error fetching data:", error);
      setUserPostsFetchError(true);
    }
  };

  useEffect(() => {
    fetchUserData();
    fetchUserPosts();

    const intervalId = setInterval(fetchUserPosts, 5000);
    return () => clearInterval(intervalId);
  }, [id]);

  return (
    <Box>
      <Header />
      <Box
        sx={{
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          minHeight: "75vh",
        }}
      >
        {userFetchError ? (
          <Error errorMessage={"Failed to Fetch User"} />
        ) : (
          <Box>
            <img
              src={ProfilePicture}
              alt="Profile pic"
              style={{
                width: "150px",
                height: "150px",
                borderRadius: "50%",
                margin: "1rem",
                display: "block",
                marginLeft: "auto",
                marginRight: "auto",
              }}
            />

            <Box
              alignItems="center"
              sx={{
                display: "flex",
                flexDirection: "column",
              }}
            >
              <Typography variant="h2" sx={{ textTransform: "capitalize" }}>
                {userData?.name}
              </Typography>

              <Stack direction="row" alignItems="center">
                <Stack direction="row" alignItems="center">
                  <IconButton color="primary">
                    <DateRange fontSize="small" color="secondary" />
                  </IconButton>
                  <Typography variant="p" color="primary">
                    {userData?.birthDate?.year}-{userData?.birthDate?.month}-
                    {userData?.birthDate?.day}
                  </Typography>
                </Stack>

                <Stack direction="row" alignItems="center" margin={"0.5rem"}>
                  <IconButton color="primary">
                    <Phone fontSize="small" color="secondary" />
                  </IconButton>
                  <Typography variant="p" color="primary">
                    {userData?.mobileNumber}
                  </Typography>
                </Stack>
              </Stack>
            </Box>
          </Box>
        )}
        <Divider sx={{ bgcolor: "primary.main", width: "100%" }} />
        {userPostsFetchError ? (
          <Error errorMessage={"Failed to Fetch Posts"} />
        ) : (
          <Container
            style={{
              display: "flex",
              flexDirection: "column",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            {userPosts.length === 0 ? (
              <Typography sx={{ margin: "2rem" }}>
                {"You have not posted anything yet."}
              </Typography>
            ) : (
              userPosts.map((item, index) => (
                <PostCard key={index} data={item} />
              ))
            )}
          </Container>
        )}
      </Box>
      <Footer />
    </Box>
  );
}
