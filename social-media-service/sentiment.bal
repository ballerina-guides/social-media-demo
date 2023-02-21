type Probability record {
    decimal neg;
    decimal neutral;
    decimal pos;
};

type Sentiment record {
    Probability probability;
    string label;
};