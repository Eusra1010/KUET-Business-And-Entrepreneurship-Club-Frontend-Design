<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="event-details.aspx.cs" Inherits="KBEC.event_details" %><!DOCTYPE html><html lang="en"><head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details</title>
    <link rel="stylesheet" href="kbec.css">
    <style>
        .details {
            padding-top: 120px;
            max-width: 900px;
            margin: auto;
        }

        .details-header {
            margin-bottom: 24px;
        }

        .details img {
            width: 100%;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .details h1 {
            margin-bottom: 20px;
        }

        .details p {
            color: #aaa;
            line-height: 1.7;
            white-space: pre-line;
        }

        .event-links {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }
    </style></head><body>

    <section class="details">
        <div class="details-header">
            <a href="kbec.aspx" class="back-home-btn">&#8592; Back</a>
        </div>

        <img id="eventImage" src="" alt="Event" />
        <h1 id="eventTitle"></h1>
        <div class="event-location">
            &#128205; <span id="eventLocation"></span>
        </div>
        <p id="eventDesc"></p>
        <div class="event-links">
            <!-- FIXED: Added explicit default href attribute so JS can rewrite it reliably -->
            <a id="registerBtn" href="#" target="_blank" rel="noopener noreferrer" class="register-btn">
                Register Now
            </a>
            <a id="facebookBtn" href="#" target="_blank" rel="noopener noreferrer" class="register-btn" style="display:none;">
                Facebook Page
            </a>
        </div>
    </section>

    <!-- FIXED: Added a version cache-buster (?v=2) to force your browser to read the updated JS modifications -->
    <script src="event-details.js?v=2"></script></body></html>