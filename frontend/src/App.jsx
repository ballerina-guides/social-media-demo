import HomePage from "./pages/HomePage"
import {
  BrowserRouter,
  Route,
  Routes
} from "react-router-dom"

function App() {

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomePage />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
