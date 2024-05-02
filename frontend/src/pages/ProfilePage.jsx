import { Box, Container, IconButton, Stack, Typography } from "@mui/material";
import PostCard from "../components/PostCard";
import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import Header from "../components/Header";
import ProfilePicture from "../assets/profile-picture.png";
import DateRange from "@mui/icons-material/DateRange";
import Phone from "@mui/icons-material/Phone";
import axios from "axios";

export default function ProfilePage() {
    const [userData, setUserData] = useState([]);
    const [userPosts, setUserPosts] = useState([]);
    const { id } = useParams();

    const fetchUserData = async () => {
        try {
            const response = await axios.get(
                `http://localhost:9090/social-media/users/${id}`
            );
            setUserData(response.data);
        } catch (error) {
            console.error("Error fetching data:", error);
            handleError(error);
        }
    };

    const fetchUserPosts = async () => {
        try {
            const response = await axios.get(
                `http://localhost:9090/social-media/users/${id}/posts`
            );
            setUserPosts(response.data);
        } catch (error) {
            console.error("Error fetching data:", error);
            handleError(error);
        }
    };

    useEffect(() => {
        fetchUserData();
        fetchUserPosts();

        const intervalId = setInterval(fetchUserPosts, 5000);
        return () => clearInterval(intervalId);
    }, [id])

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
                <img
                    src={ProfilePicture}
                    alt="Profile pic"
                    style={{
                        width: "150px",
                        height: "150px",
                        borderRadius: "50%",
                        margin: "1rem",
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
                                {userData?.birthDate?.year}-{userData?.birthDate?.month}-{userData?.birthDate?.day}
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
                        userPosts.map((item, index) => <PostCard key={index} data={item} />)
                    )}
                </Container>
            </Box>
        </Box>
    );
}
