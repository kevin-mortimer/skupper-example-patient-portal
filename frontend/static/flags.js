export function renderCountryFlag(value) {
      const flagEmoji = countryToEmoji(value);
      return `${flagEmoji}`;
}

export function renderCountryWithFlag(value) {
      const flagEmoji = countryToEmoji(value);
      return `${flagEmoji} ${value}`;
}

export function countryToEmoji(countryCode) {
      if (!countryCode) return "";
      return countryCode
          .toUpperCase()
          .replace(/./g, char => String.fromCodePoint(127397 + char.charCodeAt()));
}
