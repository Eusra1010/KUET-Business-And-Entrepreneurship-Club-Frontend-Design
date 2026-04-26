// EVENT DATA (Add all events here)
const eventsData = {
    tedx: {
        title: "TEDxKUET",
        image: "tedx.jpg",
        desc: `
TEDxKUET is an independently organized TEDx event hosted by the KUET Business & Entrepreneurship Club as part of the global TEDx program. It gathers thought leaders, innovators, and change-makers to share inspiring ideas that spark meaningful dialogue, reflection, and action.

The inaugural edition took place on November 4, 2022, themed 'Break The Barrier,' featuring live talks and compelling storytelling. TEDxKUET serves as a vital platform for students and the community to explore ideas in entrepreneurship, technology, leadership, creativity, social impact, and innovation, while continuing to bring globally recognized idea-sharing events to the KUET campus.

Summary
TEDxKUET - independently organized by KBEC under the global TEDx banner, launched November 4, 2022 with 'Break The Barrier' theme, fostering ideas in entrepreneurship, technology, leadership, and innovation at KUET.
        `,
        location: "KUET Auditorium, Khulna",
        registerLink: "https://example.com/register-tedx",
        facebookLink: "https://www.facebook.com/events/2439190826531758"
    }
};

function setLink(anchorEl, url) {
    if (!anchorEl) return;
    if (!url) {
        anchorEl.hidden = true;
        anchorEl.removeAttribute('href');
        return;
    }

    anchorEl.hidden = false;
    anchorEl.href = url;
}

function loadEvent() {
    const params = new URLSearchParams(window.location.search);
    const eventKey = params.get("event") || Object.keys(eventsData)[0];

    if (!eventKey || !eventsData[eventKey]) {
        document.body.innerHTML = `
            <h1 style="text-align:center; margin-top:100px;">Event not found</h1>
        `;
        return;
    }

    const event = eventsData[eventKey];

    const titleEl = document.getElementById("eventTitle");
    const imageEl = document.getElementById("eventImage");
    const descEl = document.getElementById("eventDesc");
    const locationEl = document.getElementById("eventLocation");

    if (titleEl) titleEl.innerText = event.title || "";
    if (imageEl) {
        imageEl.src = event.image || "";
        imageEl.alt = event.title || "Event image";
    }
    if (descEl) descEl.innerText = event.desc || "";
    if (locationEl) locationEl.innerText = event.location || "";

    setLink(document.getElementById("registerBtn"), event.registerLink);
    setLink(document.getElementById("facebookBtn"), event.facebookLink);

    document.title = event.title || document.title;
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadEvent);
} else {
    loadEvent();
}
