# Snowflake Interview Questions

This document contains interview questions and answers collected throughout the project.

Q: Why did you create DIM_LOCATION?

Answer:

Location names, boroughs and service zones are descriptive attributes.

Instead of storing these values millions of times inside the Fact table, we store only the Location ID and retrieve the descriptive information through joins. This reduces storage, improves maintainability and follows dimensional modeling best practices.

Q: Why did you create a Date Dimension?

Answer:

The Date Dimension stores commonly used calendar attributes such as year, quarter, month, week, day and weekend indicator. This avoids recalculating these values during every analytical query and improves query performance.

Q: Why use a Fact table?

Answer:

The Fact table stores measurable business events such as taxi trips, fare amount and trip distance while referencing Dimension tables through foreign keys. This forms a Star Schema optimized for analytics.