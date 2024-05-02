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

import { Button, Container, IconButton } from "@mui/material";
import DeleteIcon from "@mui/icons-material/Delete";
import { useNavigate } from "react-router-dom";

export default function UserProfileButton({ user, deleteUser }) {
    const navigate = useNavigate();

    const handleUserButtonClick = () => {
        navigate(`/user/${user.id}`);
    };

    return (
        <Container
            sx={{
                display: "flex",
                justifyContent: "center",
            }}
        >
            <Button
                variant="contained"
                color="primary"
                sx={{
                    padding: "1rem 2rem",
                    minWidth: "10rem",
                    width: "100%",
                    margin: "0.5rem",
                    borderRadius: "0.5rem",
                    color: "white",
                    textTransform: "capitalize",
                }}
                onClick={handleUserButtonClick}
            >
                {user.name}
            </Button>
            <IconButton aria-label="delete" onClick={() => deleteUser(user.id)}>
                <DeleteIcon />
            </IconButton>
        </Container>
    );
}
